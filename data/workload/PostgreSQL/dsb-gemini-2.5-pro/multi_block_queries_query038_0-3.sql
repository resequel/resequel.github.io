
SELECT count(*)
FROM
  (SELECT DISTINCT c1.c_customer_sk,
                   d1.d_date_sk
   FROM store_sales ss
   JOIN date_dim d1 ON ss.ss_sold_date_sk = d1.d_date_sk
   JOIN customer c1 ON ss.ss_customer_sk = c1.c_customer_sk
   JOIN catalog_sales cs ON ss.ss_customer_sk = cs.cs_bill_customer_sk
   AND ss.ss_sold_date_sk = cs.cs_sold_date_sk
   JOIN date_dim d2 ON cs.cs_sold_date_sk = d2.d_date_sk
   JOIN customer c2 ON cs.cs_bill_customer_sk = c2.c_customer_sk
   JOIN web_sales ws ON ss.ss_customer_sk = ws.ws_bill_customer_sk
   AND ss.ss_sold_date_sk = ws.ws_sold_date_sk
   JOIN date_dim d3 ON ws.ws_sold_date_sk = d3.d_date_sk
   JOIN customer c3 ON ws.ws_bill_customer_sk = c3.c_customer_sk
   WHERE d1.d_month_seq BETWEEN 1185 AND 1185 + 11
     AND c1.c_birth_month IN (2,
                           3,
                           10,
                           12)
     AND ss.ss_list_price BETWEEN 28 AND 87
     AND ss.ss_wholesale_cost BETWEEN 80 AND 100
     AND d2.d_month_seq BETWEEN 1185 AND 1185 + 11
     AND c2.c_birth_month IN (2,
                           3,
                           10,
                           12)
     AND cs.cs_list_price BETWEEN 28 AND 87
     AND cs.cs_wholesale_cost BETWEEN 80 AND 100
     AND d3.d_month_seq BETWEEN 1185 AND 1185 + 11
     AND c3.c_birth_month IN (2,
                           3,
                           10,
                           12)
     AND ws.ws_list_price BETWEEN 28 AND 87
     AND ws.ws_wholesale_cost BETWEEN 80 AND 100) hot_cust
LIMIT 100;