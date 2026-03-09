WITH frequent_ss_items AS MATERIALIZED
  (SELECT i_item_sk
   FROM store_sales
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   JOIN item ON ss_item_sk = i_item_sk
   WHERE d_year = 2001
     AND i_manager_id BETWEEN 77 AND 96
     AND i_category IN ('Books',
                        'Jewelry',
                        'Sports')
   GROUP BY substring(i_item_desc, 1, 30), i_item_sk, d_date
   HAVING count(*) > 4),
     max_store_sales AS MATERIALIZED
  (SELECT max(csales) AS tpcds_cmax
   FROM
     (SELECT sum(ss_quantity*ss_sales_price) AS csales
      FROM store_sales
      JOIN customer ON ss_customer_sk = c_customer_sk
      JOIN date_dim ON ss_sold_date_sk = d_date_sk
      WHERE d_year = 2001
        AND ss_wholesale_cost BETWEEN 2 AND 12
      GROUP BY c_customer_sk) tmp1),
     best_ss_customer AS MATERIALIZED
  (SELECT c_customer_sk
   FROM store_sales
   JOIN customer ON ss_customer_sk = c_customer_sk
   WHERE c_birth_year BETWEEN 1977 AND 1983
   GROUP BY c_customer_sk
   HAVING sum(ss_quantity*ss_sales_price) > (
                                               (SELECT tpcds_cmax
                                                FROM max_store_sales) * (95/100.0)))
SELECT sum(sales)
FROM
  (SELECT cs_quantity*cs_list_price sales
   FROM catalog_sales
   JOIN date_dim ON cs_sold_date_sk = d_date_sk
   WHERE d_year = 2001
     AND d_moy = 10
     AND cs_wholesale_cost BETWEEN 2 AND 12
     AND EXISTS
       (SELECT 1
        FROM frequent_ss_items fsi
        WHERE fsi.i_item_sk = cs_item_sk)
     AND EXISTS
       (SELECT 1
        FROM best_ss_customer bsc
        WHERE bsc.c_customer_sk = cs_bill_customer_sk)
   UNION ALL SELECT ws_quantity*ws_list_price sales
   FROM web_sales
   JOIN date_dim ON ws_sold_date_sk = d_date_sk
   WHERE d_year = 2001
     AND d_moy = 10
     AND ws_wholesale_cost BETWEEN 2 AND 12
     AND EXISTS
       (SELECT 1
        FROM frequent_ss_items fsi
        WHERE fsi.i_item_sk = ws_item_sk)
     AND EXISTS
       (SELECT 1
        FROM best_ss_customer bsc
        WHERE bsc.c_customer_sk = ws_bill_customer_sk)) tmp2
LIMIT 100;