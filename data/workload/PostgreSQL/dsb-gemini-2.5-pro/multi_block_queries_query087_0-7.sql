WITH filtered_dates AS
  (SELECT d_date_sk,
          d_date,
          d_month_seq
   FROM date_dim
   WHERE d_month_seq BETWEEN 1222 AND 1222+11
     OR d_month_seq BETWEEN 1222 AND 1222+11
     OR d_month_seq BETWEEN 1222 AND 1222+11),
     filtered_customers AS
  (SELECT c_customer_sk,
          c_last_name,
          c_first_name,
          c_birth_year
   FROM customer
   WHERE c_birth_year BETWEEN 1958 AND 1964
     OR c_birth_year BETWEEN 1958 AND 1964
     OR c_birth_year BETWEEN 1958 AND 1964)
SELECT count(*)
FROM
  (SELECT DISTINCT c.c_last_name,
                   c.c_first_name,
                   d.d_date
   FROM store_sales ss
   JOIN filtered_dates d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN filtered_customers c ON ss.ss_customer_sk = c.c_customer_sk
   WHERE d.d_month_seq BETWEEN 1222 AND 1222+11
     AND ss.ss_list_price BETWEEN 269 AND 298
     AND c.c_birth_year BETWEEN 1958 AND 1964
     AND ss.ss_wholesale_cost BETWEEN 90 AND 100
   EXCEPT SELECT DISTINCT c.c_last_name,
                          c.c_first_name,
                          d.d_date
   FROM catalog_sales cs
   JOIN filtered_dates d ON cs.cs_sold_date_sk = d.d_date_sk
   JOIN filtered_customers c ON cs.cs_bill_customer_sk = c.c_customer_sk
   WHERE d.d_month_seq BETWEEN 1222 AND 1222+11
     AND cs.cs_list_price BETWEEN 269 AND 298
     AND c.c_birth_year BETWEEN 1958 AND 1964
     AND cs.cs_wholesale_cost BETWEEN 90 AND 100
   EXCEPT SELECT DISTINCT c.c_last_name,
                          c.c_first_name,
                          d.d_date
   FROM web_sales ws
   JOIN filtered_dates d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN filtered_customers c ON ws.ws_bill_customer_sk = c.c_customer_sk
   WHERE d.d_month_seq BETWEEN 1222 AND 1222+11
     AND ws.ws_list_price BETWEEN 269 AND 298
     AND c.c_birth_year BETWEEN 1958 AND 1964
     AND ws.ws_wholesale_cost BETWEEN 90 AND 100) cool_cust;