WITH sales_with_delay AS
  (SELECT cs_ship_date_sk - cs_sold_date_sk AS ship_delay,
          cs_warehouse_sk,
          cs_ship_mode_sk,
          cs_call_center_sk,
          cs_ship_date_sk
   FROM catalog_sales
   WHERE cs_list_price BETWEEN 77 AND 106),
     filtered_warehouse AS
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
               WHEN (sd.ship_delay <= 30) THEN 1
               ELSE 0
           END) AS "30 days",
       sum(CASE
               WHEN (sd.ship_delay > 30)
                    AND (sd.ship_delay <= 60) THEN 1
               ELSE 0
           END) AS "31-60 days",
       sum(CASE
               WHEN (sd.ship_delay > 60)
                    AND (sd.ship_delay <= 90) THEN 1
               ELSE 0
           END) AS "61-90 days",
       sum(CASE
               WHEN (sd.ship_delay > 90)
                    AND (sd.ship_delay <= 120) THEN 1
               ELSE 0
           END) AS "91-120 days",
       sum(CASE
               WHEN (sd.ship_delay > 120) THEN 1
               ELSE 0
           END) AS ">120 days"
FROM sales_with_delay sd
JOIN filtered_date d ON sd.cs_ship_date_sk = d.d_date_sk
JOIN filtered_warehouse w ON sd.cs_warehouse_sk = w.w_warehouse_sk
JOIN filtered_ship_mode sm ON sd.cs_ship_mode_sk = sm.sm_ship_mode_sk
JOIN filtered_call_center cc ON sd.cs_call_center_sk = cc.cc_call_center_sk
GROUP BY substring(w.w_warehouse_name, 1, 20),
         sm.sm_type,
         cc.cc_name
ORDER BY substring(w.w_warehouse_name, 1, 20),
         sm.sm_type,
         cc.cc_name
LIMIT 100;