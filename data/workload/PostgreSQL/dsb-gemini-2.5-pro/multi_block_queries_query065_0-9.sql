WITH item_level_revenue AS
  (SELECT ss_store_sk,
          ss_item_sk,
          SUM(CASE
                  WHEN d_month_seq BETWEEN 1215 AND 1215 + 11
                       AND ss_sales_price BETWEEN (ss_list_price * 22 * 0.01) AND (ss_list_price * 32 * 0.01) THEN ss_sales_price
                  ELSE 0
              END) AS revenue_sc,
          SUM(CASE
                  WHEN d_month_seq BETWEEN 1215 AND 1215 + 11
                       AND ss_sales_price BETWEEN (ss_list_price * 22 * 0.01) AND (ss_list_price * 32 * 0.01) THEN ss_sales_price
                  ELSE 0
              END) AS revenue_sb
   FROM store_sales
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   WHERE d_month_seq BETWEEN LEAST(1215, 1215) AND GREATEST(1215 + 11, 1215 + 11)
   GROUP BY ss_store_sk,
            ss_item_sk)
SELECT s.s_store_name,
       i.i_item_desc,
       ilr.revenue_sc,
       i.i_current_price,
       i.i_wholesale_cost,
       i.i_brand
FROM item_level_revenue ilr
JOIN
  (SELECT ss_store_sk,
          AVG(revenue_sb) AS ave
   FROM item_level_revenue
   WHERE revenue_sb > 0
   GROUP BY ss_store_sk) sar ON ilr.ss_store_sk = sar.ss_store_sk
JOIN store s ON ilr.ss_store_sk = s.s_store_sk
JOIN item i ON ilr.ss_item_sk = i.i_item_sk
WHERE ilr.revenue_sc > 0
  AND ilr.revenue_sc <= 0.1 * sar.ave
  AND s.s_state IN ('GA',
                  'IL',
                  'TX')
  AND i.i_manager_id BETWEEN 16 AND 20
ORDER BY s.s_store_name,
         i.i_item_desc
LIMIT 100;