WITH period_sales AS
  (SELECT ss.ss_store_sk,
          d.d_week_seq,
          d.d_day_name,
          ss.ss_sales_price,
          1 AS period_num
   FROM store_sales ss
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN store s ON ss.ss_store_sk = s.s_store_sk
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
   UNION ALL SELECT ss.ss_store_sk,
                    d.d_week_seq,
                    d.d_day_name,
                    ss.ss_sales_price,
                    2 AS period_num
   FROM store_sales ss
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN store s ON ss.ss_store_sk = s.s_store_sk
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
     AND (ss.ss_sales_price / ss.ss_list_price) BETWEEN 17 * 0.01 AND 37 * 0.01),
     weekly_sales AS
  (SELECT ss_store_sk,
          d_week_seq,
          period_num,
          sum(CASE
                  WHEN d_day_name = 'Sunday' THEN ss_sales_price
                  ELSE NULL
              END) AS sun_sales,
          sum(CASE
                  WHEN d_day_name = 'Monday' THEN ss_sales_price
                  ELSE NULL
              END) AS mon_sales,
          sum(CASE
                  WHEN d_day_name = 'Tuesday' THEN ss_sales_price
                  ELSE NULL
              END) AS tue_sales,
          sum(CASE
                  WHEN d_day_name = 'Wednesday' THEN ss_sales_price
                  ELSE NULL
              END) AS wed_sales,
          sum(CASE
                  WHEN d_day_name = 'Thursday' THEN ss_sales_price
                  ELSE NULL
              END) AS thu_sales,
          sum(CASE
                  WHEN d_day_name = 'Friday' THEN ss_sales_price
                  ELSE NULL
              END) AS fri_sales,
          sum(CASE
                  WHEN d_day_name = 'Saturday' THEN ss_sales_price
                  ELSE NULL
              END) AS sat_sales
   FROM period_sales
   GROUP BY ss_store_sk,
            d_week_seq,
            period_num)
SELECT s.s_store_name,
       s.s_store_id,
       y.d_week_seq,
       y.sun_sales / x.sun_sales,
       y.mon_sales / x.mon_sales,
       y.tue_sales / x.tue_sales,
       y.wed_sales / x.wed_sales,
       y.thu_sales / x.thu_sales,
       y.fri_sales / x.fri_sales,
       y.sat_sales / x.sat_sales
FROM
  (SELECT *
   FROM weekly_sales
   WHERE period_num = 1) AS y
JOIN
  (SELECT *
   FROM weekly_sales
   WHERE period_num = 2) AS x ON y.ss_store_sk = x.ss_store_sk
AND y.d_week_seq = x.d_week_seq - 52
JOIN store s ON y.ss_store_sk = s.s_store_sk
ORDER BY s.s_store_name,
         s.s_store_id,
         y.d_week_seq
LIMIT 100;