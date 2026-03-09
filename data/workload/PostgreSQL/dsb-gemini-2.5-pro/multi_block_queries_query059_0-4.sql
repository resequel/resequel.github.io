WITH date1_keys AS
  (SELECT d_date_sk,
          d_week_seq,
          d_day_name
   FROM date_dim
   WHERE d_month_seq BETWEEN 1207 AND 1207 + 11),
     date2_keys AS
  (SELECT d_date_sk,
          d_week_seq,
          d_day_name
   FROM date_dim
   WHERE d_month_seq BETWEEN 1207 + 12 AND 1207 + 23),
     store1_keys AS
  (SELECT s_store_sk,
          s_store_name,
          s_store_id
   FROM store
   WHERE s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')),
     store2_keys AS
  (SELECT s_store_sk,
          s_store_name,
          s_store_id
   FROM store
   WHERE s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NM',
                     'OH',
                     'OR',
                     'TX')),
     wss1 AS
  (SELECT d.d_week_seq,
          s.s_store_name,
          s.s_store_id,
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
   JOIN date1_keys d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN store1_keys s ON ss.ss_store_sk = s.s_store_sk
   WHERE ss.ss_list_price > 0
     AND ss.ss_sales_price BETWEEN ss.ss_list_price * (17 * 0.01) AND ss.ss_list_price * (37 * 0.01)
   GROUP BY d.d_week_seq,
            s.s_store_name,
            s.s_store_id),
     wss2 AS
  (SELECT d.d_week_seq,
          s.s_store_name,
          s.s_store_id,
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
   JOIN date2_keys d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN store2_keys s ON ss.ss_store_sk = s.s_store_sk
   WHERE ss.ss_list_price > 0
     AND ss.ss_sales_price BETWEEN ss.ss_list_price * (17 * 0.01) AND ss.ss_list_price * (37 * 0.01)
   GROUP BY d.d_week_seq,
            s.s_store_name,
            s.s_store_id)
SELECT wss1.s_store_name,
       wss1.s_store_id,
       wss1.d_week_seq,
       wss1.sun_sales / wss2.sun_sales,
       wss1.mon_sales / wss2.mon_sales,
       wss1.tue_sales / wss2.tue_sales,
       wss1.wed_sales / wss2.wed_sales,
       wss1.thu_sales / wss2.thu_sales,
       wss1.fri_sales / wss2.fri_sales,
       wss1.sat_sales / wss2.sat_sales
FROM wss1
JOIN wss2 ON wss1.s_store_id = wss2.s_store_id
AND wss1.d_week_seq = wss2.d_week_seq - 52
ORDER BY wss1.s_store_name,
         wss1.s_store_id,
         wss1.d_week_seq
LIMIT 100;