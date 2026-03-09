
SELECT w_details.warehouse_name_part,
       sm.sm_type,
       cc.cc_name,
       COUNT(*) FILTER (
                        WHERE cs.cs_ship_date_sk - cs.cs_sold_date_sk <= 30) AS "30 days",
       COUNT(*) FILTER (
                        WHERE cs.cs_ship_date_sk - cs.cs_sold_date_sk > 30
                          AND cs.cs_ship_date_sk - cs.cs_sold_date_sk <= 60) AS "31-60 days",
       COUNT(*) FILTER (
                        WHERE cs.cs_ship_date_sk - cs.cs_sold_date_sk > 60
                          AND cs.cs_ship_date_sk - cs.cs_sold_date_sk <= 90) AS "61-90 days",
       COUNT(*) FILTER (
                        WHERE cs.cs_ship_date_sk - cs.cs_sold_date_sk > 90
                          AND cs.cs_ship_date_sk - cs.cs_sold_date_sk <= 120) AS "91-120 days",
       COUNT(*) FILTER (
                        WHERE cs.cs_ship_date_sk - cs.cs_sold_date_sk > 120) AS ">120 days"
FROM catalog_sales cs
JOIN date_dim d ON cs.cs_ship_date_sk = d.d_date_sk
JOIN
  (SELECT w_warehouse_sk,
          substring(w_warehouse_name, 1, 20) AS warehouse_name_part
   FROM warehouse
   WHERE w_gmt_offset = -5) AS w_details ON cs.cs_warehouse_sk = w_details.w_warehouse_sk
JOIN ship_mode sm ON cs.cs_ship_mode_sk = sm.sm_ship_mode_sk
JOIN call_center cc ON cs.cs_call_center_sk = cc.cc_call_center_sk
WHERE d.d_month_seq BETWEEN 1193 AND 1193 + 23
  AND cs.cs_list_price BETWEEN 77 AND 106
  AND sm.sm_type = 'TWO DAY'
  AND cc.cc_class = 'small'
GROUP BY w_details.warehouse_name_part,
         sm.sm_type,
         cc.cc_name
ORDER BY w_details.warehouse_name_part,
         sm.sm_type,
         cc.cc_name
LIMIT 100;