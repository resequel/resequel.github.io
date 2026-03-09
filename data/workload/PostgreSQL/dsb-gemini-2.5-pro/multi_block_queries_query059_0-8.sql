WITH weekly_sales AS
  (SELECT CASE
              WHEN (d.d_month_seq BETWEEN 1207 AND 1207 + 11
                    AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')) THEN d.d_week_seq
              WHEN (d.d_month_seq BETWEEN 1207 + 12 AND 1207 + 23
                    AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')) THEN d.d_week_seq - 52
          END AS d_week_seq_normalized,
          s.s_store_name,
          s.s_store_id,
          SUM(ss_sales_price) FILTER (
                                      WHERE d.d_day_name = 'Sunday'
                                        AND d.d_month_seq BETWEEN 1207 AND 1207 + 11
                                        AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')) AS sun_sales1,
          SUM(ss_sales_price) FILTER (
                                      WHERE d.d_day_name = 'Monday'
                                        AND d.d_month_seq BETWEEN 1207 AND 1207 + 11
                                        AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')) AS mon_sales1,
          SUM(ss_sales_price) FILTER (
                                      WHERE d.d_day_name = 'Tuesday'
                                        AND d.d_month_seq BETWEEN 1207 AND 1207 + 11
                                        AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')) AS tue_sales1,
          SUM(ss_sales_price) FILTER (
                                      WHERE d.d_day_name = 'Wednesday'
                                        AND d.d_month_seq BETWEEN 1207 AND 1207 + 11
                                        AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')) AS wed_sales1,
          SUM(ss_sales_price) FILTER (
                                      WHERE d.d_day_name = 'Thursday'
                                        AND d.d_month_seq BETWEEN 1207 AND 1207 + 11
                                        AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')) AS thu_sales1,
          SUM(ss_sales_price) FILTER (
                                      WHERE d.d_day_name = 'Friday'
                                        AND d.d_month_seq BETWEEN 1207 AND 1207 + 11
                                        AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')) AS fri_sales1,
          SUM(ss_sales_price) FILTER (
                                      WHERE d.d_day_name = 'Saturday'
                                        AND d.d_month_seq BETWEEN 1207 AND 1207 + 11
                                        AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')) AS sat_sales1,
          SUM(ss_sales_price) FILTER (
                                      WHERE d.d_day_name = 'Sunday'
                                        AND d.d_month_seq BETWEEN 1207 + 12 AND 1207 + 23
                                        AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')) AS sun_sales2,
          SUM(ss_sales_price) FILTER (
                                      WHERE d.d_day_name = 'Monday'
                                        AND d.d_month_seq BETWEEN 1207 + 12 AND 1207 + 23
                                        AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')) AS mon_sales2,
          SUM(ss_sales_price) FILTER (
                                      WHERE d.d_day_name = 'Tuesday'
                                        AND d.d_month_seq BETWEEN 1207 + 12 AND 1207 + 23
                                        AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')) AS tue_sales2,
          SUM(ss_sales_price) FILTER (
                                      WHERE d.d_day_name = 'Wednesday'
                                        AND d.d_month_seq BETWEEN 1207 + 12 AND 1207 + 23
                                        AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')) AS wed_sales2,
          SUM(ss_sales_price) FILTER (
                                      WHERE d.d_day_name = 'Thursday'
                                        AND d.d_month_seq BETWEEN 1207 + 12 AND 1207 + 23
                                        AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')) AS thu_sales2,
          SUM(ss_sales_price) FILTER (
                                      WHERE d.d_day_name = 'Friday'
                                        AND d.d_month_seq BETWEEN 1207 + 12 AND 1207 + 23
                                        AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')) AS fri_sales2,
          SUM(ss_sales_price) FILTER (
                                      WHERE d.d_day_name = 'Saturday'
                                        AND d.d_month_seq BETWEEN 1207 + 12 AND 1207 + 23
                                        AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')) AS sat_sales2
   FROM store_sales ss
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN store s ON ss.ss_store_sk = s.s_store_sk
   WHERE ss.ss_list_price > 0
     AND ss.ss_sales_price BETWEEN ss.ss_list_price * (17 * 0.01) AND ss.ss_list_price * (37 * 0.01)
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
   GROUP BY s.s_store_name,
            s.s_store_id,
            d_week_seq_normalized)
SELECT s_store_name,
       s_store_id,
       d_week_seq_normalized,
       sun_sales1 / sun_sales2,
       mon_sales1 / mon_sales2,
       tue_sales1 / tue_sales2,
       wed_sales1 / wed_sales2,
       thu_sales1 / thu_sales2,
       fri_sales1 / fri_sales2,
       sat_sales1 / sat_sales2
FROM weekly_sales
WHERE sun_sales2 > 0
  AND mon_sales2 > 0
  AND tue_sales2 > 0
  AND wed_sales2 > 0
  AND thu_sales2 > 0
  AND fri_sales2 > 0
  AND sat_sales2 > 0
ORDER BY s_store_name,
         s_store_id,
         d_week_seq_normalized
LIMIT 100;