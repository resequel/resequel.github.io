
SELECT count(*)
FROM
  (SELECT DISTINCT c_last_name,
                   c_first_name,
                   d_date
   FROM store_sales,
        date_dim,
        customer
   WHERE ss_sold_date_sk = d_date_sk
     AND ss_customer_sk = c_customer_sk
     AND d_month_seq BETWEEN 1222 AND 1222+11
     AND ss_list_price BETWEEN 269 AND 298
     AND c_birth_year BETWEEN 1958 AND 1964
     AND ss_wholesale_cost BETWEEN 90 AND 100
   EXCEPT
     (SELECT DISTINCT c_last_name,
                      c_first_name,
                      d_date
      FROM catalog_sales,
           date_dim,
           customer
      WHERE cs_sold_date_sk = d_date_sk
        AND cs_bill_customer_sk = c_customer_sk
        AND d_month_seq BETWEEN 1222 AND 1222+11
        AND cs_list_price BETWEEN 269 AND 298
        AND c_birth_year BETWEEN 1958 AND 1964
        AND cs_wholesale_cost BETWEEN 90 AND 100
      UNION ALL SELECT DISTINCT c_last_name,
                                c_first_name,
                                d_date
      FROM web_sales,
           date_dim,
           customer
      WHERE ws_sold_date_sk = d_date_sk
        AND ws_bill_customer_sk = c_customer_sk
        AND d_month_seq BETWEEN 1222 AND 1222+11
        AND ws_list_price BETWEEN 269 AND 298
        AND c_birth_year BETWEEN 1958 AND 1964
        AND ws_wholesale_cost BETWEEN 90 AND 100)) cool_cust;