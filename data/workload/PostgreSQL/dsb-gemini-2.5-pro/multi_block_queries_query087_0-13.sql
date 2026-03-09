WITH d1 AS
  (SELECT d_date_sk,
          d_date
   FROM date_dim
   WHERE d_month_seq BETWEEN 1222 AND 1222+11),
     c1 AS
  (SELECT c_customer_sk,
          c_last_name,
          c_first_name
   FROM customer
   WHERE c_birth_year BETWEEN 1958 AND 1964)
SELECT count(*)
FROM
  (SELECT DISTINCT c1.c_last_name,
                   c1.c_first_name,
                   d1.d_date
   FROM store_sales ss
   JOIN d1 ON ss.ss_sold_date_sk = d1.d_date_sk
   JOIN c1 ON ss.ss_customer_sk = c1.c_customer_sk
   WHERE ss.ss_list_price BETWEEN 269 AND 298
     AND ss.ss_wholesale_cost BETWEEN 90 AND 100
     AND NOT EXISTS
       (SELECT 1
        FROM catalog_sales cs
        JOIN date_dim d2 ON cs.cs_sold_date_sk = d2.d_date_sk
        JOIN customer c2 ON cs.cs_bill_customer_sk = c2.c_customer_sk
        WHERE c1.c_last_name = c2.c_last_name
          AND c1.c_first_name = c2.c_first_name
          AND d1.d_date = d2.d_date
          AND d2.d_month_seq BETWEEN 1222 AND 1222+11
          AND cs.cs_list_price BETWEEN 269 AND 298
          AND c2.c_birth_year BETWEEN 1958 AND 1964
          AND cs.cs_wholesale_cost BETWEEN 90 AND 100)
     AND NOT EXISTS
       (SELECT 1
        FROM web_sales ws
        JOIN date_dim d3 ON ws.ws_sold_date_sk = d3.d_date_sk
        JOIN customer c3 ON ws.ws_bill_customer_sk = c3.c_customer_sk
        WHERE c1.c_last_name = c3.c_last_name
          AND c1.c_first_name = c3.c_first_name
          AND d1.d_date = d3.d_date
          AND d3.d_month_seq BETWEEN 1222 AND 1222+11
          AND ws.ws_list_price BETWEEN 269 AND 298
          AND c3.c_birth_year BETWEEN 1958 AND 1964
          AND ws.ws_wholesale_cost BETWEEN 90 AND 100)) cool_cust;