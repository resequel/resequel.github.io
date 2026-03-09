WITH daily_sales AS
  (SELECT s.s_store_id,
          s.s_store_name,
          d.d_week_seq,
          CASE
              WHEN d.d_month_seq BETWEEN 1207 AND 1207 + 11
                   AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX') THEN 1
              WHEN d.d_month_seq BETWEEN 1207 + 12 AND 1207 + 23
                   AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX') THEN 2
          END AS period_num,
          sum(CASE
                  WHEN d.d_day_name = 'Sunday' THEN ss.ss_sales_price
              END) AS sun_sales,
          sum(CASE
                  WHEN d.d_day_name = 'Monday' THEN ss.ss_sales_price
              END) AS mon_sales,
          sum(CASE
                  WHEN d.d_day_name = 'Tuesday' THEN ss.ss_sales_price
              END) AS tue_sales,
          sum(CASE
                  WHEN d.d_day_name = 'Wednesday' THEN ss.ss_sales_price
              END) AS wed_sales,
          sum(CASE
                  WHEN d.d_day_name = 'Thursday' THEN ss.ss_sales_price
              END) AS thu_sales,
          sum(CASE
                  WHEN d.d_day_name = 'Friday' THEN ss.ss_sales_price
              END) AS fri_sales,
          sum(CASE
                  WHEN d.d_day_name = 'Saturday' THEN ss.ss_sales_price
              END) AS sat_sales
   FROM store_sales ss
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN store s ON ss.ss_store_sk = s.s_store_sk
   WHERE ss.ss_list_price > 0
     AND (ss.ss_sales_price / ss.ss_list_price) BETWEEN 17 * 0.01 AND 37 * 0.01
     AND ((d.d_month_seq BETWEEN 1207 AND 1207 + 11
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
   GROUP BY s.s_store_id,
            s.s_store_name,
            d.d_week_seq,
            period_num),
     sales_comparison AS
  (SELECT s_store_name,
          s_store_id,
          d_week_seq,
          sun_sales,
          mon_sales,
          tue_sales,
          wed_sales,
          thu_sales,
          fri_sales,
          sat_sales,
          LEAD(sun_sales) OVER (PARTITION BY s_store_id
                                ORDER BY period_num) AS next_sun,
          LEAD(mon_sales) OVER (PARTITION BY s_store_id
                                ORDER BY period_num) AS next_mon,
          LEAD(tue_sales) OVER (PARTITION BY s_store_id
                                ORDER BY period_num) AS next_tue,
          LEAD(wed_sales) OVER (PARTITION BY s_store_id
                                ORDER BY period_num) AS next_wed,
          LEAD(thu_sales) OVER (PARTITION BY s_store_id
                                ORDER BY period_num) AS next_thu,
          LEAD(fri_sales) OVER (PARTITION BY s_store_id
                                ORDER BY period_num) AS next_fri,
          LEAD(sat_sales) OVER (PARTITION BY s_store_id
                                ORDER BY period_num) AS next_sat,
          LEAD(d_week_seq) OVER (PARTITION BY s_store_id
                                 ORDER BY period_num) AS next_week
   FROM daily_sales)
SELECT s_store_name,
       s_store_id,
       d_week_seq,
       sun_sales / next_sun,
       mon_sales / next_mon,
       tue_sales / next_tue,
       wed_sales / next_wed,
       thu_sales / next_thu,
       fri_sales / next_fri,
       sat_sales / next_sat
FROM sales_comparison
WHERE d_week_seq = next_week - 52
ORDER BY s_store_name,
         s_store_id,
         d_week_seq
LIMIT 100;