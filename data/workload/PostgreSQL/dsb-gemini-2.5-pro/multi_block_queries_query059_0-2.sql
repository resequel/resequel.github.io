WITH sales_period1 AS
  (SELECT s.s_store_name,
          s.s_store_id,
          d.d_week_seq,
          sum(CASE
                  WHEN d.d_day_name = 'Sunday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS sun_sales,
          sum(CASE
                  WHEN d.d_day_name = 'Monday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS mon_sales,
          sum(CASE
                  WHEN d.d_day_name = 'Tuesday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS tue_sales,
          sum(CASE
                  WHEN d.d_day_name = 'Wednesday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS wed_sales,
          sum(CASE
                  WHEN d.d_day_name = 'Thursday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS thu_sales,
          sum(CASE
                  WHEN d.d_day_name = 'Friday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS fri_sales,
          sum(CASE
                  WHEN d.d_day_name = 'Saturday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS sat_sales
   FROM store_sales AS ss
   JOIN date_dim AS d ON d.d_date_sk = ss.ss_sold_date_sk
   JOIN store AS s ON ss.ss_store_sk = s.s_store_sk
   WHERE d.d_month_seq BETWEEN 1207 AND 1207 + 11
     AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')
     AND ss.ss_list_price > 0
     AND (ss.ss_sales_price / ss.ss_list_price) BETWEEN 17 * 0.01 AND 37 * 0.01
   GROUP BY s.s_store_name,
            s.s_store_id,
            d.d_week_seq),
     sales_period2 AS
  (SELECT s.s_store_name,
          s.s_store_id,
          d.d_week_seq,
          sum(CASE
                  WHEN d.d_day_name = 'Sunday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS sun_sales,
          sum(CASE
                  WHEN d.d_day_name = 'Monday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS mon_sales,
          sum(CASE
                  WHEN d.d_day_name = 'Tuesday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS tue_sales,
          sum(CASE
                  WHEN d.d_day_name = 'Wednesday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS wed_sales,
          sum(CASE
                  WHEN d.d_day_name = 'Thursday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS thu_sales,
          sum(CASE
                  WHEN d.d_day_name = 'Friday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS fri_sales,
          sum(CASE
                  WHEN d.d_day_name = 'Saturday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS sat_sales
   FROM store_sales AS ss
   JOIN date_dim AS d ON d.d_date_sk = ss.ss_sold_date_sk
   JOIN store AS s ON ss.ss_store_sk = s.s_store_sk
   WHERE d.d_month_seq BETWEEN 1207 + 12 AND 1207 + 23
     AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')
     AND ss.ss_list_price > 0
     AND (ss.ss_sales_price / ss.ss_list_price) BETWEEN 17 * 0.01 AND 37 * 0.01
   GROUP BY s.s_store_name,
            s.s_store_id,
            d.d_week_seq)
SELECT y.s_store_name,
       y.s_store_id,
       y.d_week_seq,
       y.sun_sales / x.sun_sales,
       y.mon_sales / x.mon_sales,
       y.tue_sales / x.tue_sales,
       y.wed_sales / x.wed_sales,
       y.thu_sales / x.thu_sales,
       y.fri_sales / x.fri_sales,
       y.sat_sales / x.sat_sales
FROM sales_period1 AS y
JOIN sales_period2 AS x ON y.s_store_id = x.s_store_id
AND y.d_week_seq = x.d_week_seq - 52
ORDER BY y.s_store_name,
         y.s_store_id,
         y.d_week_seq
LIMIT 100;