
SELECT COUNT(DISTINCT T1.c_last_name, T1.c_first_name, T2.d_date)
FROM customer AS T1
JOIN date_dim AS T2 ON T2.d_month_seq BETWEEN 1222 AND 1222+11
WHERE T1.c_birth_year BETWEEN 1958 AND 1964
  AND EXISTS
    (SELECT 1
     FROM store_sales AS T3
     WHERE T3.ss_customer_sk = T1.c_customer_sk
       AND T3.ss_sold_date_sk = T2.d_date_sk
       AND T3.ss_list_price BETWEEN 269 AND 298
       AND T3.ss_wholesale_cost BETWEEN 90 AND 100)
  AND NOT EXISTS
    (SELECT 1
     FROM catalog_sales AS T4
     JOIN date_dim AS T5 ON T4.cs_sold_date_sk = T5.d_date_sk
     JOIN customer AS T6 ON T4.cs_bill_customer_sk = T6.c_customer_sk
     WHERE T1.c_last_name = T6.c_last_name
       AND T1.c_first_name = T6.c_first_name
       AND T2.d_date = T5.d_date
       AND T5.d_month_seq BETWEEN 1222 AND 1222+11
       AND T4.cs_list_price BETWEEN 269 AND 298
       AND T6.c_birth_year BETWEEN 1958 AND 1964
       AND T4.cs_wholesale_cost BETWEEN 90 AND 100)
  AND NOT EXISTS
    (SELECT 1
     FROM web_sales AS T7
     JOIN date_dim AS T8 ON T7.ws_sold_date_sk = T8.d_date_sk
     JOIN customer AS T9 ON T7.ws_bill_customer_sk = T9.c_customer_sk
     WHERE T1.c_last_name = T9.c_last_name
       AND T1.c_first_name = T9.c_first_name
       AND T2.d_date = T8.d_date
       AND T8.d_month_seq BETWEEN 1222 AND 1222+11
       AND T7.ws_list_price BETWEEN 269 AND 298
       AND T9.c_birth_year BETWEEN 1958 AND 1964
       AND T7.ws_wholesale_cost BETWEEN 90 AND 100);