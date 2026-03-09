WITH sales_periods AS
  (SELECT ss_store_sk,
          ss_item_sk,
          ss_sales_price,
          'sc' AS period
   FROM store_sales
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   WHERE d_month_seq BETWEEN 1215 AND 1215 + 11
     AND ss_sales_price BETWEEN (ss_list_price * 22 * 0.01) AND (ss_list_price * 32 * 0.01)
   UNION ALL SELECT ss_store_sk,
                    ss_item_sk,
                    ss_sales_price,
                    'sb' AS period
   FROM store_sales
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   WHERE d_month_seq BETWEEN 1215 AND 1215 + 11
     AND ss_sales_price BETWEEN (ss_list_price * 22 * 0.01) AND (ss_list_price * 32 * 0.01)),
     revenue_data AS
  (SELECT ss_store_sk,
          ss_item_sk,
          SUM(CASE
                  WHEN period = 'sc' THEN ss_sales_price
                  ELSE 0
              END) AS revenue_sc,
          SUM(CASE
                  WHEN period = 'sb' THEN ss_sales_price
                  ELSE 0
              END) AS revenue_sb
   FROM sales_periods
   GROUP BY ss_store_sk,
            ss_item_sk),
     store_avg_revenue AS
  (SELECT ss_store_sk,
          AVG(revenue_sb) AS ave
   FROM revenue_data
   WHERE revenue_sb > 0
   GROUP BY ss_store_sk)
SELECT s.s_store_name,
       i.i_item_desc,
       rd.revenue_sc,
       i.i_current_price,
       i.i_wholesale_cost,
       i.i_brand
FROM revenue_data rd
JOIN store_avg_revenue sar ON rd.ss_store_sk = sar.ss_store_sk
JOIN store s ON rd.ss_store_sk = s.s_store_sk
JOIN item i ON rd.ss_item_sk = i.i_item_sk
WHERE rd.revenue_sc > 0
  AND rd.revenue_sc <= 0.1 * sar.ave
  AND s.s_state IN ('GA',
                  'IL',
                  'TX')
  AND i.i_manager_id BETWEEN 16 AND 20
ORDER BY s.s_store_name,
         i.i_item_desc
LIMIT 100;