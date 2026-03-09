WITH wss1 AS
  (SELECT d.d_week_seq,
          ss.ss_store_sk,
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
   WHERE d.d_month_seq BETWEEN 1207 AND 1207 + 11
     AND ss.ss_list_price > 0
     AND ss.ss_sales_price BETWEEN ss.ss_list_price * (17 * 0.01) AND ss.ss_list_price * (37 * 0.01)
     AND ss.ss_store_sk IN
       (SELECT s_store_sk
        FROM store
        WHERE s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX'))
   GROUP BY d.d_week_seq,
            ss.ss_store_sk),
     wss2 AS
  (SELECT d.d_week_seq,
          ss.ss_store_sk,
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
   WHERE d.d_month_seq BETWEEN 1207 + 12 AND 1207 + 23
     AND ss.ss_list_price > 0
     AND ss.ss_sales_price BETWEEN ss.ss_list_price * (17 * 0.01) AND ss.ss_list_price * (37 * 0.01)
     AND ss.ss_store_sk IN
       (SELECT s_store_sk
        FROM store
        WHERE s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX'))
   GROUP BY d.d_week_seq,
            ss.ss_store_sk)
SELECT s.s_store_name,
       s.s_store_id,
       wss1.d_week_seq,
       wss1.sun_sales / wss2.sun_sales,
       wss1.mon_sales / wss2.mon_sales,
       wss1.tue_sales / wss2.tue_sales,
       wss1.wed_sales / wss2.wed_sales,
       wss1.thu_sales / wss2.thu_sales,
       wss1.fri_sales / wss2.fri_sales,
       wss1.sat_sales / wss2.sat_sales
FROM wss1
JOIN wss2 ON wss1.ss_store_sk = wss2.ss_store_sk
AND wss1.d_week_seq = wss2.d_week_seq - 52
JOIN store s ON wss1.ss_store_sk = s.s_store_sk
ORDER BY s.s_store_name,
         s.s_store_id,
         wss1.d_week_seq
LIMIT 100;