WITH filtered_cs AS
  (SELECT cs_sold_date_sk,
          cs_ship_date_sk,
          cs_warehouse_sk,
          cs_ship_mode_sk,
          cs_call_center_sk
   FROM catalog_sales
   WHERE cs_list_price BETWEEN 77 AND 106)
SELECT substring(w.w_warehouse_name, 1, 20),
       sm.sm_type,
       cc.cc_name,
       COUNT(*) FILTER (
                        WHERE fcs.cs_ship_date_sk - fcs.cs_sold_date_sk <= 30) AS "30 days",
       COUNT(*) FILTER (
                        WHERE fcs.cs_ship_date_sk - fcs.cs_sold_date_sk > 30
                          AND fcs.cs_ship_date_sk - fcs.cs_sold_date_sk <= 60) AS "31-60 days",
       COUNT(*) FILTER (
                        WHERE fcs.cs_ship_date_sk - fcs.cs_sold_date_sk > 60
                          AND fcs.cs_ship_date_sk - fcs.cs_sold_date_sk <= 90) AS "61-90 days",
       COUNT(*) FILTER (
                        WHERE fcs.cs_ship_date_sk - fcs.cs_sold_date_sk > 90
                          AND fcs.cs_ship_date_sk - fcs.cs_sold_date_sk <= 120) AS "91-120 days",
       COUNT(*) FILTER (
                        WHERE fcs.cs_ship_date_sk - fcs.cs_sold_date_sk > 120) AS ">120 days"
FROM filtered_cs fcs
JOIN date_dim d ON fcs.cs_ship_date_sk = d.d_date_sk
JOIN warehouse w ON fcs.cs_warehouse_sk = w.w_warehouse_sk
JOIN ship_mode sm ON fcs.cs_ship_mode_sk = sm.sm_ship_mode_sk
JOIN call_center cc ON fcs.cs_call_center_sk = cc.cc_call_center_sk
WHERE d.d_month_seq BETWEEN 1193 AND 1193 + 23
  AND sm.sm_type = 'TWO DAY'
  AND cc.cc_class = 'small'
  AND w.w_gmt_offset = -5
GROUP BY substring(w.w_warehouse_name, 1, 20),
         sm.sm_type,
         cc.cc_name
ORDER BY substring(w.w_warehouse_name, 1, 20),
         sm.sm_type,
         cc.cc_name
LIMIT 100;