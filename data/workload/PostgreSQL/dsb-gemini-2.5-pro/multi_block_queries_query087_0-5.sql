
SELECT COUNT(*)
FROM
  (SELECT DISTINCT c.c_last_name,
                   c.c_first_name,
                   d.d_date
   FROM store_sales
   JOIN date_dim d ON ss_sold_date_sk = d.d_date_sk
   JOIN customer c ON ss_customer_sk = c.c_customer_sk
   WHERE d.d_month_seq BETWEEN 1222 AND 1222+11
     AND ss_list_price BETWEEN 269 AND 298
     AND c.c_birth_year BETWEEN 1958 AND 1964
     AND ss_wholesale_cost BETWEEN 90 AND 100
     AND NOT EXISTS
       (SELECT 1
        FROM catalog_sales cs,
             date_dim d2,
             customer c2
        WHERE cs.cs_sold_date_sk = d2.d_date_sk
          AND cs.cs_bill_customer_sk = c2.c_customer_sk
          AND c2.c_last_name = c.c_last_name
          AND c2.c_first_name = c.c_first_name
          AND d2.d_date = d.d_date
          AND d2.d_month_seq BETWEEN 1222 AND 1222+11
          AND cs.cs_list_price BETWEEN 269 AND 298
          AND c2.c_birth_year BETWEEN 1958 AND 1964
          AND cs.cs_wholesale_cost BETWEEN 90 AND 100)
     AND NOT EXISTS
       (SELECT 1
        FROM web_sales ws,
             date_dim d3,
             customer c3
        WHERE ws.ws_sold_date_sk = d3.d_date_sk
          AND ws.ws_bill_customer_sk = c3.c_customer_sk
          AND c3.c_last_name = c.c_last_name
          AND c3.c_first_name = c.c_first_name
          AND d3.d_date = d.d_date
          AND d3.d_month_seq BETWEEN 1222 AND 1222+11
          AND ws.ws_list_price BETWEEN 269 AND 298
          AND c3.c_birth_year BETWEEN 1958 AND 1964
          AND ws.ws_wholesale_cost BETWEEN 90 AND 100)) cool_cust;