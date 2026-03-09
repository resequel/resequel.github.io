WITH filtered_warehouse AS
  (SELECT w_warehouse_sk,
          w_warehouse_name
   FROM warehouse
   WHERE w_gmt_offset = -5),
     filtered_ship_mode AS
  (SELECT sm_ship_mode_sk,
          sm_type
   FROM ship_mode
   WHERE sm_type = 'TWO DAY'),
     filtered_call_center AS
  (SELECT cc_call_center_sk,
          cc_name
   FROM call_center
   WHERE cc_class = 'small'),
     filtered_date AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_month_seq BETWEEN 1193 AND 1193 + 23)
SELECT substring(w.w_warehouse_name, 1, 20),
       sm.sm_type,
       cc.cc_name,
       sum(CASE
               WHEN (cs.cs_ship_date_sk - cs.cs_sold_date_sk <= 30) THEN 1
               ELSE 0
           END) AS "30 days",
       sum(CASE
               WHEN (cs.cs_ship_date_sk - cs.cs_sold_date_sk > 30)
                    AND (cs.cs_ship_date_sk - cs.cs_sold_date_sk <= 60) THEN 1
               ELSE 0
           END) AS "31-60 days",
       sum(CASE
               WHEN (cs.cs_ship_date_sk - cs.cs_sold_date_sk > 60)
                    AND (cs.cs_ship_date_sk - cs.cs_sold_date_sk <= 90) THEN 1
               ELSE 0
           END) AS "61-90 days",
       sum(CASE
               WHEN (cs.cs_ship_date_sk - cs.cs_sold_date_sk > 90)
                    AND (cs.cs_ship_date_sk - cs.cs_sold_date_sk <= 120) THEN 1
               ELSE 0
           END) AS "91-120 days",
       sum(CASE
               WHEN (cs.cs_ship_date_sk - cs.cs_sold_date_sk > 120) THEN 1
               ELSE 0
           END) AS ">120 days"
FROM catalog_sales cs
JOIN filtered_date d ON cs.cs_ship_date_sk = d.d_date_sk
JOIN filtered_warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
JOIN filtered_ship_mode sm ON cs.cs_ship_mode_sk = sm.sm_ship_mode_sk
JOIN filtered_call_center cc ON cs.cs_call_center_sk = cc.cc_call_center_sk
WHERE cs.cs_list_price BETWEEN 77 AND 106
GROUP BY substring(w.w_warehouse_name, 1, 20),
         sm.sm_type,
         cc.cc_name
ORDER BY substring(w.w_warehouse_name, 1, 20),
         sm.sm_type,
         cc.cc_name
LIMIT 100;