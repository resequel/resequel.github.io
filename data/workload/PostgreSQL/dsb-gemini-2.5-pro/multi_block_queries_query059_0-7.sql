WITH filtered_dates1 AS
  (SELECT d_date_sk,
          d_week_seq,
          d_day_name
   FROM date_dim
   WHERE d_month_seq BETWEEN 1207 AND 1207 + 11),
     filtered_stores1 AS
  (SELECT s_store_sk
   FROM store
   WHERE s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')),
     sales_period1 AS
  (SELECT ss.ss_store_sk,
          fd.d_week_seq,
          sum(CASE
                  WHEN fd.d_day_name = 'Sunday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS sun_sales,
          sum(CASE
                  WHEN fd.d_day_name = 'Monday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS mon_sales,
          sum(CASE
                  WHEN fd.d_day_name = 'Tuesday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS tue_sales,
          sum(CASE
                  WHEN fd.d_day_name = 'Wednesday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS wed_sales,
          sum(CASE
                  WHEN fd.d_day_name = 'Thursday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS thu_sales,
          sum(CASE
                  WHEN fd.d_day_name = 'Friday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS fri_sales,
          sum(CASE
                  WHEN fd.d_day_name = 'Saturday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS sat_sales
   FROM store_sales ss
   JOIN filtered_dates1 fd ON ss.ss_sold_date_sk = fd.d_date_sk
   JOIN filtered_stores1 fs ON ss.ss_store_sk = fs.s_store_sk
   WHERE ss.ss_list_price > 0
     AND (ss.ss_sales_price / ss.ss_list_price) BETWEEN 17 * 0.01 AND 37 * 0.01
   GROUP BY ss.ss_store_sk,
            fd.d_week_seq),
     filtered_dates2 AS
  (SELECT d_date_sk,
          d_week_seq,
          d_day_name
   FROM date_dim
   WHERE d_month_seq BETWEEN 1207 + 12 AND 1207 + 23),
     filtered_stores2 AS
  (SELECT s_store_sk
   FROM store
   WHERE s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')),
     sales_period2 AS
  (SELECT ss.ss_store_sk,
          fd.d_week_seq,
          sum(CASE
                  WHEN fd.d_day_name = 'Sunday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS sun_sales,
          sum(CASE
                  WHEN fd.d_day_name = 'Monday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS mon_sales,
          sum(CASE
                  WHEN fd.d_day_name = 'Tuesday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS tue_sales,
          sum(CASE
                  WHEN fd.d_day_name = 'Wednesday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS wed_sales,
          sum(CASE
                  WHEN fd.d_day_name = 'Thursday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS thu_sales,
          sum(CASE
                  WHEN fd.d_day_name = 'Friday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS fri_sales,
          sum(CASE
                  WHEN fd.d_day_name = 'Saturday' THEN ss.ss_sales_price
                  ELSE NULL
              END) AS sat_sales
   FROM store_sales ss
   JOIN filtered_dates2 fd ON ss.ss_sold_date_sk = fd.d_date_sk
   JOIN filtered_stores2 fs ON ss.ss_store_sk = fs.s_store_sk
   WHERE ss.ss_list_price > 0
     AND (ss.ss_sales_price / ss.ss_list_price) BETWEEN 17 * 0.01 AND 37 * 0.01
   GROUP BY ss.ss_store_sk,
            fd.d_week_seq)
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
FROM sales_period1 AS y
JOIN sales_period2 AS x ON y.ss_store_sk = x.ss_store_sk
AND y.d_week_seq = x.d_week_seq - 52
JOIN store AS s ON y.ss_store_sk = s.s_store_sk
ORDER BY s.s_store_name,
         s.s_store_id,
         y.d_week_seq
LIMIT 100;