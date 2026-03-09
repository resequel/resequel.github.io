WITH store_customers AS
  (SELECT DISTINCT c.c_last_name,
                   c.c_first_name,
                   d.d_date
   FROM store_sales
   JOIN date_dim d ON ss_sold_date_sk = d.d_date_sk
   JOIN customer c ON ss_customer_sk = c.c_customer_sk
   WHERE d.d_month_seq BETWEEN 1222 AND 1222+11
     AND ss_list_price BETWEEN 269 AND 298
     AND c.c_birth_year BETWEEN 1958 AND 1964
     AND ss_wholesale_cost BETWEEN 90 AND 100),
     excluded_customers AS
  (SELECT DISTINCT c.c_last_name,
                   c.c_first_name,
                   d.d_date
   FROM catalog_sales
   JOIN date_dim d ON cs_sold_date_sk = d.d_date_sk
   JOIN customer c ON cs_bill_customer_sk = c.c_customer_sk
   WHERE d.d_month_seq BETWEEN 1222 AND 1222+11
     AND cs_list_price BETWEEN 269 AND 298
     AND c.c_birth_year BETWEEN 1958 AND 1964
     AND cs_wholesale_cost BETWEEN 90 AND 100
   UNION SELECT DISTINCT c.c_last_name,
                         c.c_first_name,
                         d.d_date
   FROM web_sales
   JOIN date_dim d ON ws_sold_date_sk = d.d_date_sk
   JOIN customer c ON ws_bill_customer_sk = c.c_customer_sk
   WHERE d.d_month_seq BETWEEN 1222 AND 1222+11
     AND ws_list_price BETWEEN 269 AND 298
     AND c.c_birth_year BETWEEN 1958 AND 1964
     AND ws_wholesale_cost BETWEEN 90 AND 100)
SELECT count(*)
FROM store_customers sc
LEFT JOIN excluded_customers ec ON sc.c_last_name = ec.c_last_name
AND sc.c_first_name = ec.c_first_name
AND sc.d_date = ec.d_date
WHERE ec.c_last_name IS NULL;