WITH sales_by_period AS
  (SELECT 1 AS period,
          d.d_week_seq,
          s.s_store_id,
          s.s_store_name,
          SUM(ss.ss_sales_price) FILTER (
                                         WHERE d.d_day_name = 'Sunday') AS sun_sales,
          SUM(ss.ss_sales_price) FILTER (
                                         WHERE d.d_day_name = 'Monday') AS mon_sales,
          SUM(ss.ss_sales_price) FILTER (
                                         WHERE d.d_day_name = 'Tuesday') AS tue_sales,
          SUM(ss.ss_sales_price) FILTER (
                                         WHERE d.d_day_name = 'Wednesday') AS wed_sales,
          SUM(ss.ss_sales_price) FILTER (
                                         WHERE d.d_day_name = 'Thursday') AS thu_sales,
          SUM(ss.ss_sales_price) FILTER (
                                         WHERE d.d_day_name = 'Friday') AS fri_sales,
          SUM(ss.ss_sales_price) FILTER (
                                         WHERE d.d_day_name = 'Saturday') AS sat_sales
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
     AND ss.ss_sales_price BETWEEN ss.ss_list_price * (17 * 0.01) AND ss.ss_list_price * (37 * 0.01)
   GROUP BY d.d_week_seq,
            s.s_store_id,
            s.s_store_name
   UNION ALL SELECT 2 AS period,
                    d.d_week_seq,
                    s.s_store_id,
                    s.s_store_name,
                    SUM(ss.ss_sales_price) FILTER (
                                                   WHERE d.d_day_name = 'Sunday') AS sun_sales,
                    SUM(ss.ss_sales_price) FILTER (
                                                   WHERE d.d_day_name = 'Monday') AS mon_sales,
                    SUM(ss.ss_sales_price) FILTER (
                                                   WHERE d.d_day_name = 'Tuesday') AS tue_sales,
                    SUM(ss.ss_sales_price) FILTER (
                                                   WHERE d.d_day_name = 'Wednesday') AS wed_sales,
                    SUM(ss.ss_sales_price) FILTER (
                                                   WHERE d.d_day_name = 'Thursday') AS thu_sales,
                    SUM(ss.ss_sales_price) FILTER (
                                                   WHERE d.d_day_name = 'Friday') AS fri_sales,
                    SUM(ss.ss_sales_price) FILTER (
                                                   WHERE d.d_day_name = 'Saturday') AS sat_sales
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
     AND ss.ss_sales_price BETWEEN ss.ss_list_price * (17 * 0.01) AND ss.ss_list_price * (37 * 0.01)
   GROUP BY d.d_week_seq,
            s.s_store_id,
            s.s_store_name)
SELECT p1.s_store_name,
       p1.s_store_id,
       p1.d_week_seq,
       p1.sun_sales / p2.sun_sales,
       p1.mon_sales / p2.mon_sales,
       p1.tue_sales / p2.tue_sales,
       p1.wed_sales / p2.wed_sales,
       p1.thu_sales / p2.thu_sales,
       p1.fri_sales / p2.fri_sales,
       p1.sat_sales / p2.sat_sales
FROM sales_by_period p1
JOIN sales_by_period p2 ON p1.s_store_id = p2.s_store_id
AND p1.d_week_seq = p2.d_week_seq - 52
WHERE p1.period = 1
  AND p2.period = 2
ORDER BY p1.s_store_name,
         p1.s_store_id,
         p1.d_week_seq
LIMIT 100;