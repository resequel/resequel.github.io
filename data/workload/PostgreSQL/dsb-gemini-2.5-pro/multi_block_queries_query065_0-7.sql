WITH revenue_data AS
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
   JOIN store ON ss_store_sk = s_store_sk
   JOIN item ON ss_item_sk = i_item_sk
   WHERE s_state IN ('GA',
                  'IL',
                  'TX')
     AND i_manager_id BETWEEN 16 AND 20
     AND (d_month_seq BETWEEN 1215 AND 1215 + 11
          OR d_month_seq BETWEEN 1215 AND 1215 + 11)
   GROUP BY ss_store_sk,
            ss_item_sk),
     revenue_with_avg AS
  (SELECT ss_store_sk,
          ss_item_sk,
          revenue_sc,
          AVG(NULLIF(revenue_sb, 0)) OVER (PARTITION BY ss_store_sk) AS ave
   FROM revenue_data)
SELECT s.s_store_name,
       i.i_item_desc,
       r.revenue_sc,
       i.i_current_price,
       i.i_wholesale_cost,
       i.i_brand
FROM revenue_with_avg r
JOIN store s ON r.ss_store_sk = s.s_store_sk
JOIN item i ON r.ss_item_sk = i.i_item_sk
WHERE r.revenue_sc > 0
  AND r.ave IS NOT NULL
  AND r.revenue_sc <= 0.1 * r.ave
ORDER BY s.s_store_name,
         i.i_item_desc
LIMIT 100;