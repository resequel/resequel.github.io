
SELECT count(*)
FROM (
        (SELECT c_last_name,
                c_first_name,
                d_date
         FROM store_sales,
              date_dim,
              customer
         WHERE store_sales.ss_sold_date_sk = date_dim.d_date_sk
           AND store_sales.ss_customer_sk = customer.c_customer_sk
           AND d_month_seq BETWEEN 1222 AND 1222+11
           AND ss_list_price BETWEEN 269 AND 298
           AND c_birth_year BETWEEN 1958 AND 1964
           AND ss_wholesale_cost BETWEEN 90 AND 100
         GROUP BY 1,
                  2,
                  3)
      EXCEPT
        (SELECT c_last_name,
                c_first_name,
                d_date
         FROM catalog_sales,
              date_dim,
              customer
         WHERE catalog_sales.cs_sold_date_sk = date_dim.d_date_sk
           AND catalog_sales.cs_bill_customer_sk = customer.c_customer_sk
           AND d_month_seq BETWEEN 1222 AND 1222+11
           AND cs_list_price BETWEEN 269 AND 298
           AND c.c_birth_year BETWEEN 1958 AND 1964
           AND cs_wholesale_cost BETWEEN 90 AND 100
         GROUP BY 1,
                  2,
                  3)
      EXCEPT
        (SELECT c_last_name,
                c_first_name,
                d_date
         FROM web_sales,
              date_dim,
              customer
         WHERE web_sales.ws_sold_date_sk = date_dim.d_date_sk
           AND web_sales.ws_bill_customer_sk = customer.c_customer_sk
           AND d_month_seq BETWEEN 1222 AND 1222+11
           AND ws_list_price BETWEEN 269 AND 298
           AND c.c_birth_year BETWEEN 1958 AND 1964
           AND ws_wholesale_cost BETWEEN 90 AND 100
         GROUP BY 1,
                  2,
                  3)) cool_cust;