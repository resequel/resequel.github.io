WITH all_sales_customers AS
  (SELECT ss_customer_sk AS customer_sk,
          1 AS channel
   FROM store_sales
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   WHERE d_month_seq BETWEEN 1185 AND 1185 + 11
     AND ss_list_price BETWEEN 28 AND 87
     AND ss_wholesale_cost BETWEEN 80 AND 100
   UNION ALL SELECT cs_bill_customer_sk,
                    2 AS channel
   FROM catalog_sales
   JOIN date_dim ON cs_sold_date_sk = d_date_sk
   WHERE d_month_seq BETWEEN 1185 AND 1185 + 11
     AND cs_list_price BETWEEN 28 AND 87
     AND cs_wholesale_cost BETWEEN 80 AND 100
   UNION ALL SELECT ws_bill_customer_sk,
                    3 AS channel
   FROM web_sales
   JOIN date_dim ON ws_sold_date_sk = d_date_sk
   WHERE d_month_seq BETWEEN 1185 AND 1185 + 11
     AND ws_list_price BETWEEN 28 AND 87
     AND ws_wholesale_cost BETWEEN 80 AND 100)
SELECT count(*)
FROM
  (SELECT ascust.customer_sk
   FROM all_sales_customers ascust
   JOIN customer c ON ascust.customer_sk = c.c_customer_sk
   WHERE c.c_birth_month IN (2,
                           3,
                           10,
                           12)
     AND c.c_birth_month IN (2,
                           3,
                           10,
                           12)
     AND c.c_birth_month IN (2,
                           3,
                           10,
                           12)
   GROUP BY ascust.customer_sk
   HAVING count(DISTINCT channel) = 3) hot_cust
LIMIT 100;