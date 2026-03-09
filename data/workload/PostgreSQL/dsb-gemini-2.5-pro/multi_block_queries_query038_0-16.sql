WITH filtered_customers AS
  (SELECT c_customer_sk
   FROM customer
   WHERE c_birth_month IN (2,
                           3,
                           10,
                           12)
     AND c_birth_month IN (2,
                           3,
                           10,
                           12)
     AND c_birth_month IN (2,
                           3,
                           10,
                           12)),
     store_sales_filtered AS
  (SELECT ss_customer_sk
   FROM store_sales
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   WHERE d_month_seq BETWEEN 1185 AND 1185 + 11
     AND ss_list_price BETWEEN 28 AND 87
     AND ss_wholesale_cost BETWEEN 80 AND 100),
     catalog_sales_filtered AS
  (SELECT cs_bill_customer_sk
   FROM catalog_sales
   JOIN date_dim ON cs_sold_date_sk = d_date_sk
   WHERE d_month_seq BETWEEN 1185 AND 1185 + 11
     AND cs_list_price BETWEEN 28 AND 87
     AND cs_wholesale_cost BETWEEN 80 AND 100),
     web_sales_filtered AS
  (SELECT ws_bill_customer_sk
   FROM web_sales
   JOIN date_dim ON ws_sold_date_sk = d_date_sk
   WHERE d_month_seq BETWEEN 1185 AND 1185 + 11
     AND ws_list_price BETWEEN 28 AND 87
     AND ws_wholesale_cost BETWEEN 80 AND 100)
SELECT COUNT(DISTINCT fc.c_customer_sk)
FROM filtered_customers fc
JOIN store_sales_filtered ssf ON fc.c_customer_sk = ssf.ss_customer_sk
JOIN catalog_sales_filtered csf ON fc.c_customer_sk = csf.cs_bill_customer_sk
JOIN web_sales_filtered wsf ON fc.c_customer_sk = wsf.ws_bill_customer_sk
LIMIT 100;