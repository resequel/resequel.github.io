WITH store_sales_filtered AS
  (SELECT ss.ss_customer_sk,
          ss.ss_sold_date_sk
   FROM store_sales ss
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
   WHERE d.d_month_seq BETWEEN 1185 AND 1185 + 11
     AND c.c_birth_month IN (2,
                           3,
                           10,
                           12)
     AND ss.ss_list_price BETWEEN 28 AND 87
     AND ss.ss_wholesale_cost BETWEEN 80 AND 100),
     catalog_sales_filtered AS
  (SELECT cs.cs_bill_customer_sk,
          cs.cs_sold_date_sk
   FROM catalog_sales cs
   JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
   JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk
   WHERE d.d_month_seq BETWEEN 1185 AND 1185 + 11
     AND c.c_birth_month IN (2,
                           3,
                           10,
                           12)
     AND cs.cs_list_price BETWEEN 28 AND 87
     AND cs.cs_wholesale_cost BETWEEN 80 AND 100),
     web_sales_filtered AS
  (SELECT ws.ws_bill_customer_sk,
          ws.ws_sold_date_sk
   FROM web_sales ws
   JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
   WHERE d.d_month_seq BETWEEN 1185 AND 1185 + 11
     AND c.c_birth_month IN (2,
                           3,
                           10,
                           12)
     AND ws.ws_list_price BETWEEN 28 AND 87
     AND ws.ws_wholesale_cost BETWEEN 80 AND 100)
SELECT count(*)
FROM
  (SELECT DISTINCT s.ss_customer_sk,
                   s.ss_sold_date_sk
   FROM store_sales_filtered s
   JOIN catalog_sales_filtered c ON s.ss_customer_sk = c.cs_bill_customer_sk
   AND s.ss_sold_date_sk = c.cs_sold_date_sk
   JOIN web_sales_filtered w ON s.ss_customer_sk = w.ws_bill_customer_sk
   AND s.ss_sold_date_sk = w.ws_sold_date_sk) hot_cust
LIMIT 100;