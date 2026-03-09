WITH item_revenues AS
  (SELECT ss.ss_store_sk,
          ss.ss_item_sk,
          SUM(CASE
                  WHEN d.d_month_seq BETWEEN 1215 AND 1215+11
                       AND ss.ss_sales_price BETWEEN ss.ss_list_price * 22 * 0.01 AND ss.ss_list_price * 32 * 0.01 THEN ss.ss_sales_price
              END) AS revenue_a,
          SUM(CASE
                  WHEN d.d_month_seq BETWEEN 1215 AND 1215+11
                       AND ss.ss_sales_price BETWEEN ss.ss_list_price * 22 * 0.01 AND ss.ss_list_price * 32 * 0.01 THEN ss.ss_sales_price
              END) AS revenue_c
   FROM store_sales ss
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN store s ON ss.ss_store_sk = s.s_store_sk
   JOIN item i ON ss.ss_item_sk = i.i_item_sk
   WHERE s.s_state IN ('GA',
                  'IL',
                  'TX')
     AND i.i_manager_id BETWEEN 16 AND 20
     AND d.d_month_seq BETWEEN LEAST(1215, 1215) AND GREATEST(1215+11, 1215+11)
   GROUP BY ss.ss_store_sk,
            ss.ss_item_sk),
     store_avg_revenue AS
  (SELECT ss_store_sk,
          ss_item_sk,
          revenue_c,
          AVG(revenue_a) OVER (PARTITION BY ss_store_sk) AS ave
   FROM item_revenues
   WHERE revenue_c IS NOT NULL)
SELECT s.s_store_name,
       i.i_item_desc,
       sar.revenue_c AS revenue,
       i.i_current_price,
       i.i_wholesale_cost,
       i.i_brand
FROM store_avg_revenue sar
JOIN store s ON sar.ss_store_sk = s.s_store_sk
JOIN item i ON sar.ss_item_sk = i.i_item_sk
WHERE sar.revenue_c <= 0.1 * sar.ave
ORDER BY s.s_store_name,
         i.i_item_desc
LIMIT 100;