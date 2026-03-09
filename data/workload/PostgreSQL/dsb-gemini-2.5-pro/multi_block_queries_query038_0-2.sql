
SELECT count(*)
FROM customer c
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
  AND EXISTS
    (SELECT 1
     FROM store_sales ss
     JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
     WHERE ss.ss_customer_sk = c.c_customer_sk
       AND d.d_month_seq BETWEEN 1185 AND 1185 + 11
       AND ss.ss_list_price BETWEEN 28 AND 87
       AND ss.ss_wholesale_cost BETWEEN 80 AND 100)
  AND EXISTS
    (SELECT 1
     FROM catalog_sales cs
     JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
     WHERE cs.cs_bill_customer_sk = c.c_customer_sk
       AND d.d_month_seq BETWEEN 1185 AND 1185 + 11
       AND cs.cs_list_price BETWEEN 28 AND 87
       AND cs.cs_wholesale_cost BETWEEN 80 AND 100)
  AND EXISTS
    (SELECT 1
     FROM web_sales ws
     JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
     WHERE ws.ws_bill_customer_sk = c.c_customer_sk
       AND d.d_month_seq BETWEEN 1185 AND 1185 + 11
       AND ws.ws_list_price BETWEEN 28 AND 87
       AND ws.ws_wholesale_cost BETWEEN 80 AND 100)
LIMIT 100;