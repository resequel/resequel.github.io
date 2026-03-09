WITH sc_revenue AS
  (SELECT ss_store_sk,
          ss_item_sk,
          sum(ss_sales_price) AS revenue
   FROM store_sales
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   WHERE d_month_seq BETWEEN 1215 AND 1215 + 11
     AND ss_sales_price BETWEEN (ss_list_price * 22 * 0.01) AND (ss_list_price * 32 * 0.01)
   GROUP BY ss_store_sk,
            ss_item_sk)
SELECT s.s_store_name,
       i.i_item_desc,
       sc.revenue,
       i.i_current_price,
       i.i_wholesale_cost,
       i.i_brand
FROM sc_revenue sc
JOIN store s ON sc.ss_store_sk = s.s_store_sk
JOIN item i ON sc.ss_item_sk = i.i_item_sk,
               LATERAL
  (SELECT avg(sa.revenue) AS ave
   FROM
     (SELECT sum(ss.ss_sales_price) AS revenue
      FROM store_sales ss
      JOIN date_dim dd ON ss.ss_sold_date_sk = dd.d_date_sk
      WHERE ss.ss_store_sk = sc.ss_store_sk
        AND dd.d_month_seq BETWEEN 1215 AND 1215 + 11
        AND ss.ss_sales_price BETWEEN (ss.ss_list_price * 22 * 0.01) AND (ss.ss_list_price * 32 * 0.01)
      GROUP BY ss.ss_item_sk) sa) sb
WHERE sc.revenue <= 0.1 * sb.ave
  AND s.s_state IN ('GA',
                  'IL',
                  'TX')
  AND i.i_manager_id BETWEEN 16 AND 20
ORDER BY s_store_name,
         i_item_desc
LIMIT 100;