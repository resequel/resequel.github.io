WITH relevant_sales AS
  (SELECT ss.ss_store_sk,
          ss.ss_item_sk,
          d.d_month_seq,
          ss.ss_sales_price,
          ss.ss_list_price
   FROM store_sales ss
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN store s ON ss.ss_store_sk = s.s_store_sk
   JOIN item i ON ss.ss_item_sk = i.i_item_sk
   WHERE s.s_state IN ('GA',
                  'IL',
                  'TX')
     AND i.i_manager_id BETWEEN 16 AND 20),
     sa AS
  (SELECT ss_store_sk,
          ss_item_sk,
          sum(ss_sales_price) AS revenue
   FROM relevant_sales
   WHERE d_month_seq BETWEEN 1215 AND 1215+11
     AND ss_sales_price BETWEEN ss_list_price * 22 * 0.01 AND ss_list_price * 32 * 0.01
   GROUP BY ss_store_sk,
            ss_item_sk),
     sb AS
  (SELECT ss_store_sk,
          avg(revenue) AS ave
   FROM sa
   GROUP BY ss_store_sk),
     sc AS
  (SELECT ss_store_sk,
          ss_item_sk,
          sum(ss_sales_price) AS revenue
   FROM relevant_sales
   WHERE d_month_seq BETWEEN 1215 AND 1215+11
     AND ss_sales_price BETWEEN ss_list_price * 22 * 0.01 AND ss_list_price * 32 * 0.01
   GROUP BY ss_store_sk,
            ss_item_sk)
SELECT s.s_store_name,
       i.i_item_desc,
       sc.revenue,
       i.i_current_price,
       i.i_wholesale_cost,
       i.i_brand
FROM sb
JOIN sc ON sb.ss_store_sk = sc.ss_store_sk
JOIN store s ON sc.ss_store_sk = s.s_store_sk
JOIN item i ON sc.ss_item_sk = i.i_item_sk
WHERE sc.revenue <= 0.1 * sb.ave
ORDER BY s.s_store_name,
         i.i_item_desc
LIMIT 100;