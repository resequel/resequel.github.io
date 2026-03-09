WITH combined_sales AS
  (SELECT s.s_store_id,
          s.s_store_name,
          d.d_week_seq,
          sum(CASE
                  WHEN d.d_month_seq BETWEEN 1207 AND 1207 + 11
                       AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')
                       AND d.d_day_name = 'Sunday' THEN ss.ss_sales_price
                  ELSE 0
              END) AS sun_sales1,
          sum(CASE
                  WHEN d.d_month_seq BETWEEN 1207 AND 1207 + 11
                       AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')
                       AND d.d_day_name = 'Monday' THEN ss.ss_sales_price
                  ELSE 0
              END) AS mon_sales1,
          sum(CASE
                  WHEN d.d_month_seq BETWEEN 1207 AND 1207 + 11
                       AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')
                       AND d.d_day_name = 'Tuesday' THEN ss.ss_sales_price
                  ELSE 0
              END) AS tue_sales1,
          sum(CASE
                  WHEN d.d_month_seq BETWEEN 1207 AND 1207 + 11
                       AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')
                       AND d.d_day_name = 'Wednesday' THEN ss.ss_sales_price
                  ELSE 0
              END) AS wed_sales1,
          sum(CASE
                  WHEN d.d_month_seq BETWEEN 1207 AND 1207 + 11
                       AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')
                       AND d.d_day_name = 'Thursday' THEN ss.ss_sales_price
                  ELSE 0
              END) AS thu_sales1,
          sum(CASE
                  WHEN d.d_month_seq BETWEEN 1207 AND 1207 + 11
                       AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')
                       AND d.d_day_name = 'Friday' THEN ss.ss_sales_price
                  ELSE 0
              END) AS fri_sales1,
          sum(CASE
                  WHEN d.d_month_seq BETWEEN 1207 AND 1207 + 11
                       AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')
                       AND d.d_day_name = 'Saturday' THEN ss.ss_sales_price
                  ELSE 0
              END) AS sat_sales1,
          sum(CASE
                  WHEN d.d_month_seq BETWEEN 1207 + 12 AND 1207 + 23
                       AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')
                       AND d.d_day_name = 'Sunday' THEN ss.ss_sales_price
                  ELSE 0
              END) AS sun_sales2,
          sum(CASE
                  WHEN d.d_month_seq BETWEEN 1207 + 12 AND 1207 + 23
                       AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')
                       AND d.d_day_name = 'Monday' THEN ss.ss_sales_price
                  ELSE 0
              END) AS mon_sales2,
          sum(CASE
                  WHEN d.d_month_seq BETWEEN 1207 + 12 AND 1207 + 23
                       AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')
                       AND d.d_day_name = 'Tuesday' THEN ss.ss_sales_price
                  ELSE 0
              END) AS tue_sales2,
          sum(CASE
                  WHEN d.d_month_seq BETWEEN 1207 + 12 AND 1207 + 23
                       AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')
                       AND d.d_day_name = 'Wednesday' THEN ss.ss_sales_price
                  ELSE 0
              END) AS wed_sales2,
          sum(CASE
                  WHEN d.d_month_seq BETWEEN 1207 + 12 AND 1207 + 23
                       AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')
                       AND d.d_day_name = 'Thursday' THEN ss.ss_sales_price
                  ELSE 0
              END) AS thu_sales2,
          sum(CASE
                  WHEN d.d_month_seq BETWEEN 1207 + 12 AND 1207 + 23
                       AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')
                       AND d.d_day_name = 'Friday' THEN ss.ss_sales_price
                  ELSE 0
              END) AS fri_sales2,
          sum(CASE
                  WHEN d.d_month_seq BETWEEN 1207 + 12 AND 1207 + 23
                       AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')
                       AND d.d_day_name = 'Saturday' THEN ss.ss_sales_price
                  ELSE 0
              END) AS sat_sales2
   FROM store_sales AS ss
   JOIN date_dim AS d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN store AS s ON ss.ss_store_sk = s.s_store_sk
   WHERE ((d.d_month_seq BETWEEN 1207 AND 1207 + 11
           AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX'))
          OR (d.d_month_seq BETWEEN 1207 + 12 AND 1207 + 23
              AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')))
     AND ss.ss_list_price > 0
     AND (ss.ss_sales_price / ss.ss_list_price) BETWEEN 17 * 0.01 AND 37 * 0.01
   GROUP BY s.s_store_id,
            s.s_store_name,
            d.d_week_seq)
SELECT y.s_store_name,
       y.s_store_id,
       y.d_week_seq,
       y.sun_sales1 / x.sun_sales2,
       y.mon_sales1 / x.mon_sales2,
       y.tue_sales1 / x.tue_sales2,
       y.wed_sales1 / x.wed_sales2,
       y.thu_sales1 / x.thu_sales2,
       y.fri_sales1 / x.fri_sales2,
       y.sat_sales1 / x.sat_sales2
FROM combined_sales AS y
JOIN combined_sales AS x ON y.s_store_id = x.s_store_id
AND y.d_week_seq = x.d_week_seq - 52
WHERE y.sun_sales1 > 0
  AND x.sun_sales2 > 0
ORDER BY y.s_store_name,
         y.s_store_id,
         y.d_week_seq
LIMIT 100;