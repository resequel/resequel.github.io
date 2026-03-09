
SELECT COUNT(*)
FROM
  (SELECT DISTINCT c.c_last_name,
                   c.c_first_name,
                   d.d_date
   FROM store_sales ss
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
   WHERE d.d_month_seq BETWEEN 1222 AND 1222+11
     AND ss.ss_list_price BETWEEN 269 AND 298
     AND c.c_birth_year BETWEEN 1958 AND 1964
     AND ss.ss_wholesale_cost BETWEEN 90 AND 100
     AND NOT EXISTS
       (SELECT 1
        FROM
          (SELECT cs.cs_bill_customer_sk AS customer_sk,
                  cs.cs_sold_date_sk AS sold_date_sk,
                  cs.cs_list_price AS list_price,
                  cs.cs_wholesale_cost AS wholesale_cost
           FROM catalog_sales
           UNION ALL SELECT ws.ws_bill_customer_sk,
                            ws.ws_sold_date_sk,
                            ws.ws_list_price,
                            ws.ws_wholesale_cost
           FROM web_sales) sales
        JOIN customer c2 ON sales.customer_sk = c2.c_customer_sk
        JOIN date_dim d2 ON sales.sold_date_sk = d2.d_date_sk
        WHERE c2.c_last_name = c.c_last_name
          AND c2.c_first_name = c.c_first_name
          AND d2.d_date = d.d_date
          AND ((d2.d_month_seq BETWEEN 1222 AND 1222+11
                AND sales.list_price BETWEEN 269 AND 298
                AND c2.c_birth_year BETWEEN 1958 AND 1964
                AND sales.wholesale_cost BETWEEN 90 AND 100)
               OR (d2.d_month_seq BETWEEN 1222 AND 1222+11
                   AND sales.list_price BETWEEN 269 AND 298
                   AND c2.c_birth_year BETWEEN 1958 AND 1964
                   AND sales.wholesale_cost BETWEEN 90 AND 100)))) cool_cust;