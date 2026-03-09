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
          ss.ss_store_sk,
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
   GROUP BY ss.ss_store_sk,
            d_week_seq_normalized)
SELECT s.s_store_name,
       s.s_store_id,
       ws.d_week_seq_normalized,
       ws.sun_sales1 / ws.sun_sales2,
       ws.mon_sales1 / ws.mon_sales2,
       ws.tue_sales1 / ws.tue_sales2,
       ws.wed_sales1 / ws.wed_sales2,
       ws.thu_sales1 / ws.thu_sales2,
       ws.fri_sales1 / ws.fri_sales2,
       ws.sat_sales1 / ws.sat_sales2
FROM weekly_sales ws
JOIN store s ON ws.ss_store_sk = s.s_store_sk
WHERE ws.sun_sales2 > 0
  AND ws.mon_sales2 > 0
  AND ws.tue_sales2 > 0
  AND ws.wed_sales2 > 0
  AND ws.thu_sales2 > 0
  AND ws.fri_sales2 > 0
  AND ws.sat_sales2 > 0
ORDER BY s.s_store_name,
         s.s_store_id,
         ws.d_week_seq_normalized
LIMIT 100;