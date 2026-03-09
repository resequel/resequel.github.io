WITH revenue_data AS
  (SELECT ss_store_sk,
          ss_item_sk,
          s_store_name,
          i_item_desc,
          i_current_price,
          i_wholesale_cost,
          i_brand,
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
            ss_item_sk,
            s_store_name,
            i_item_desc,
            i_current_price,
            i_wholesale_cost,
            i_brand),
     revenue_with_avg AS
  (SELECT *,
          AVG(NULLIF(revenue_sb, 0)) OVER (PARTITION BY ss_store_sk) AS ave
   FROM revenue_data)
SELECT s_store_name,
       i_item_desc,
       revenue_sc,
       i_current_price,
       i_wholesale_cost,
       i_brand
FROM revenue_with_avg
WHERE revenue_sc > 0
  AND ave IS NOT NULL
  AND revenue_sc <= 0.1 * ave
ORDER BY s_store_name,
         i_item_desc
LIMIT 100;