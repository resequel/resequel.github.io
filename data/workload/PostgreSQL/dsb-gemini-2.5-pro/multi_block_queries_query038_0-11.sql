WITH store_customers AS
  (SELECT DISTINCT ss.ss_customer_sk
   FROM store_sales ss
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   WHERE d.d_month_seq BETWEEN 1185 AND 1185 + 11
     AND ss.ss_list_price BETWEEN 28 AND 87
     AND ss.ss_wholesale_cost BETWEEN 80 AND 100),
     catalog_customers AS
  (SELECT DISTINCT cs.cs_bill_customer_sk
   FROM catalog_sales cs
   JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
   WHERE d.d_month_seq BETWEEN 1185 AND 1185 + 11
     AND cs.cs_list_price BETWEEN 28 AND 87
     AND cs.cs_wholesale_cost BETWEEN 80 AND 100),
     web_customers AS
  (SELECT DISTINCT ws.ws_bill_customer_sk
   FROM web_sales ws
   JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
   WHERE d.d_month_seq BETWEEN 1185 AND 1185 + 11
     AND ws.ws_list_price BETWEEN 28 AND 87
     AND ws.ws_wholesale_cost BETWEEN 80 AND 100)
SELECT count(c.c_customer_sk)
FROM customer c
JOIN store_customers sc ON c.c_customer_sk = sc.ss_customer_sk
JOIN catalog_customers cc ON c.c_customer_sk = cc.cs_bill_customer_sk
JOIN web_customers wc ON c.c_customer_sk = wc.ws_bill_customer_sk
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