WITH filtered_date AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_month_seq BETWEEN 1193 AND 1193 + 23),
     sales_after_date_filter AS
  (SELECT cs.*
   FROM catalog_sales cs
   JOIN filtered_date fd ON cs.cs_ship_date_sk = fd.d_date_sk
   WHERE cs.cs_list_price BETWEEN 77 AND 106)
SELECT substring(w.w_warehouse_name, 1, 20),
       sm.sm_type,
       cc.cc_name,
       sum(CASE
               WHEN (sadf.cs_ship_date_sk - sadf.cs_sold_date_sk <= 30) THEN 1
               ELSE 0
           END) AS "30 days",
       sum(CASE
               WHEN (sadf.cs_ship_date_sk - sadf.cs_sold_date_sk > 30)
                    AND (sadf.cs_ship_date_sk - sadf.cs_sold_date_sk <= 60) THEN 1
               ELSE 0
           END) AS "31-60 days",
       sum(CASE
               WHEN (sadf.cs_ship_date_sk - sadf.cs_sold_date_sk > 60)
                    AND (sadf.cs_ship_date_sk - sadf.cs_sold_date_sk <= 90) THEN 1
               ELSE 0
           END) AS "61-90 days",
       sum(CASE
               WHEN (sadf.cs_ship_date_sk - sadf.cs_sold_date_sk > 90)
                    AND (sadf.cs_ship_date_sk - sadf.cs_sold_date_sk <= 120) THEN 1
               ELSE 0
           END) AS "91-120 days",
       sum(CASE
               WHEN (sadf.cs_ship_date_sk - sadf.cs_sold_date_sk > 120) THEN 1
               ELSE 0
           END) AS ">120 days"
FROM sales_after_date_filter sadf
JOIN warehouse w ON sadf.cs_warehouse_sk = w.w_warehouse_sk
JOIN ship_mode sm ON sadf.cs_ship_mode_sk = sm.sm_ship_mode_sk
JOIN call_center cc ON sadf.cs_call_center_sk = cc.cc_call_center_sk
WHERE w.w_gmt_offset = -5
  AND sm.sm_type = 'TWO DAY'
  AND cc.cc_class = 'small'
GROUP BY substring(w.w_warehouse_name, 1, 20),
         sm.sm_type,
         cc.cc_name
ORDER BY substring(w.w_warehouse_name, 1, 20),
         sm.sm_type,
         cc.cc_name
LIMIT 100;