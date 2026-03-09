WITH frequent_ss_items AS
  (SELECT DISTINCT i_item_sk AS item_sk
   FROM store_sales
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   JOIN item ON ss_item_sk = i_item_sk
   WHERE d_year = 2001
     AND i_manager_id BETWEEN 77 AND 96
     AND i_category IN ('Books',
                        'Jewelry',
                        'Sports')
   GROUP BY substring(i_item_desc, 1, 30),
            i_item_sk,
            d_date
   HAVING count(*) > 4),
     max_store_sales AS
  (SELECT max(csales) AS tpcds_cmax
   FROM
     (SELECT c_customer_sk,
             sum(ss_quantity * ss_sales_price) AS csales
      FROM store_sales
      JOIN customer ON ss_customer_sk = c_customer_sk
      JOIN date_dim ON ss_sold_date_sk = d_date_sk
      WHERE d_year = 2001
        AND ss_wholesale_cost BETWEEN 2 AND 12
      GROUP BY c_customer_sk) AS tmp1),
     best_ss_customer AS
  (SELECT DISTINCT c_customer_sk
   FROM store_sales
   JOIN customer ON ss_customer_sk = c_customer_sk
   WHERE c_birth_year BETWEEN 1977 AND 1983
   GROUP BY c_customer_sk
   HAVING sum(ss_quantity * ss_sales_price) > (
                                                 (SELECT tpcds_cmax
                                                  FROM max_store_sales) * (95 / 100.0)))
SELECT sum(sales)
FROM
  (SELECT cs_quantity * cs_list_price AS sales
   FROM catalog_sales
   JOIN date_dim ON cs_sold_date_sk = d_date_sk
   WHERE d_year = 2001
     AND d_moy = 10
     AND cs_sold_date_sk = d_date_sk
     AND cs_item_sk IN
       (SELECT item_sk
        FROM frequent_ss_items)
     AND cs_bill_customer_sk IN
       (SELECT c_customer_sk
        FROM best_ss_customer)
     AND cs_wholesale_cost BETWEEN 2 AND 12
   UNION ALL SELECT ws_quantity * ws_list_price AS sales
   FROM web_sales
   JOIN date_dim ON ws_sold_date_sk = d_date_sk
   WHERE d_year = 2001
     AND d_moy = 10
     AND ws_sold_date_sk = d_date_sk
     AND ws_item_sk IN
       (SELECT item_sk
        FROM frequent_ss_items)
     AND ws_bill_customer_sk IN
       (SELECT c_customer_sk
        FROM best_ss_customer)
     AND ws_wholesale_cost BETWEEN 2 AND 12) AS tmp2
LIMIT 100;