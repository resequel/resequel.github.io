
SELECT s_store_name,
       i_item_desc,
       sc.revenue,
       i_current_price,
       i_wholesale_cost,
       i_brand
FROM
  (SELECT ss_store_sk,
          ss_item_sk,
          sum(ss_sales_price) AS revenue
   FROM store_sales,
        date_dim
   WHERE ss_sold_date_sk = d_date_sk
     AND d_month_seq BETWEEN 1215 AND 1215 + 11
     AND ss_sales_price / ss_list_price BETWEEN 22 * 0.01 AND 32 * 0.01
   GROUP BY ss_store_sk,
            ss_item_sk) sc
JOIN store ON sc.ss_store_sk = s_store_sk
JOIN item ON sc.ss_item_sk = i_item_sk
WHERE sc.revenue <= 0.1 *
    (SELECT avg(sa.revenue)
     FROM
       (SELECT sum(ss_sales_price) AS revenue
        FROM store_sales ss,
             date_dim dd
        WHERE ss.ss_sold_date_sk = dd.d_date_sk
          AND ss.ss_store_sk = sc.ss_store_sk
          AND dd.d_month_seq BETWEEN 1215 AND 1215 + 11
          AND ss.ss_sales_price / ss.ss_list_price BETWEEN 22 * 0.01 AND 32 * 0.01
        GROUP BY ss.ss_item_sk) sa)
  AND s_state IN ('GA',
                  'IL',
                  'TX')
  AND i_manager_id BETWEEN 16 AND 20
ORDER BY s_store_name,
         i_item_desc
LIMIT 100;