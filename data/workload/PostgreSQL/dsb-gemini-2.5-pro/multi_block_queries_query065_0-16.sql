WITH sc_revenue AS
  (SELECT ss_store_sk,
          ss_item_sk,
          sum(ss_sales_price) AS revenue
   FROM store_sales
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   WHERE d_month_seq BETWEEN 1215 AND 1215 + 11
     AND ss_sales_price BETWEEN (ss_list_price * 22 * 0.01) AND (ss_list_price * 32 * 0.01)
   GROUP BY ss_store_sk,
            ss_item_sk),
     sa_revenue AS
  (SELECT ss_store_sk,
          ss_item_sk,
          sum(ss_sales_price) AS revenue
   FROM store_sales
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   WHERE d_month_seq BETWEEN 1215 AND 1215 + 11
     AND ss_sales_price BETWEEN (ss_list_price * 22 * 0.01) AND (ss_list_price * 32 * 0.01)
   GROUP BY ss_store_sk,
            ss_item_sk),
     sb_avg_revenue AS
  (SELECT ss_store_sk,
          avg(revenue) AS ave
   FROM sa_revenue
   GROUP BY ss_store_sk)
SELECT s_store_name,
       i_item_desc,
       sc.revenue,
       i_current_price,
       i_wholesale_cost,
       i_brand
FROM sc_revenue sc
JOIN sb_avg_revenue sb ON sc.ss_store_sk = sb.ss_store_sk
JOIN store s ON sc.ss_store_sk = s.s_store_sk
JOIN item i ON sc.ss_item_sk = i.i_item_sk
WHERE sc.revenue <= 0.1 * sb.ave
  AND s.s_state IN ('GA',
                  'IL',
                  'TX')
  AND i.i_manager_id BETWEEN 16 AND 20
ORDER BY s_store_name,
         i_item_desc
LIMIT 100;