WITH sales_details AS
  (SELECT substring(w.w_warehouse_name, 1, 20) AS warehouse_name_part,
          sm.sm_type,
          cc.cc_name,
          (cs.cs_ship_date_sk - cs.cs_sold_date_sk) AS shipping_delay
   FROM catalog_sales cs
   JOIN date_dim d ON cs.cs_ship_date_sk = d.d_date_sk
   JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
   JOIN ship_mode sm ON cs.cs_ship_mode_sk = sm.sm_ship_mode_sk
   JOIN call_center cc ON cs.cs_call_center_sk = cc.cc_call_center_sk
   WHERE d.d_month_seq BETWEEN 1193 AND 1193 + 23
     AND cs.cs_list_price BETWEEN 77 AND 106
     AND sm.sm_type = 'TWO DAY'
     AND cc.cc_class = 'small'
     AND w.w_gmt_offset = -5)
SELECT warehouse_name_part,
       sm_type,
       cc_name,
       COUNT(*) FILTER (
                        WHERE shipping_delay <= 30) AS "30 days",
       COUNT(*) FILTER (
                        WHERE shipping_delay > 30
                          AND shipping_delay <= 60) AS "31-60 days",
       COUNT(*) FILTER (
                        WHERE shipping_delay > 60
                          AND shipping_delay <= 90) AS "61-90 days",
       COUNT(*) FILTER (
                        WHERE shipping_delay > 90
                          AND shipping_delay <= 120) AS "91-120 days",
       COUNT(*) FILTER (
                        WHERE shipping_delay > 120) AS ">120 days"
FROM sales_details
GROUP BY warehouse_name_part,
         sm_type,
         cc_name
ORDER BY warehouse_name_part,
         sm_type,
         cc_name
LIMIT 100;