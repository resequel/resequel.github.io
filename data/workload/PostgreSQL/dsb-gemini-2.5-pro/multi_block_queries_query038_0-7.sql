
SELECT count(c.c_customer_sk)
FROM customer c
JOIN
  (SELECT DISTINCT ss_customer_sk
   FROM store_sales
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   WHERE d_month_seq BETWEEN 1185 AND 1185 + 11
     AND ss_list_price BETWEEN 28 AND 87
     AND ss_wholesale_cost BETWEEN 80 AND 100) AS s ON c.c_customer_sk = s.ss_customer_sk
JOIN
  (SELECT DISTINCT cs_bill_customer_sk
   FROM catalog_sales
   JOIN date_dim ON cs_sold_date_sk = d_date_sk
   WHERE d_month_seq BETWEEN 1185 AND 1185 + 11
     AND cs_list_price BETWEEN 28 AND 87
     AND cs_wholesale_cost BETWEEN 80 AND 100) AS cat ON c.c_customer_sk = cat.cs_bill_customer_sk
JOIN
  (SELECT DISTINCT ws_bill_customer_sk
   FROM web_sales
   JOIN date_dim ON ws_sold_date_sk = d_date_sk
   WHERE d_month_seq BETWEEN 1185 AND 1185 + 11
     AND ws_list_price BETWEEN 28 AND 87
     AND ws_wholesale_cost BETWEEN 80 AND 100) AS w ON c.c_customer_sk = w.ws_bill_customer_sk
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
LIMIT 100;