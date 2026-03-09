
SELECT count(*)
FROM
  (SELECT DISTINCT c_last_name,
                   c_first_name,
                   d_date
   FROM store_sales,
        date_dim,
        customer
   WHERE store_sales.ss_sold_date_sk = date_dim.d_date_sk
     AND store_sales.ss_customer_sk = customer.c_customer_sk
     AND d_month_seq BETWEEN 1185 AND 1185 + 11
     AND c_birth_month IN (2,
                           3,
                           10,
                           12)
     AND ss_list_price BETWEEN 28 AND 87
     AND ss_wholesale_cost BETWEEN 80 AND 100 INTERSECT SELECT DISTINCT c_last_name,
                                                                             c_first_name,
                                                                             d_date
   FROM catalog_sales,
        date_dim,
        customer
   WHERE catalog_sales.cs_sold_date_sk = date_dim.d_date_sk
     AND catalog_sales.cs_bill_customer_sk = customer.c_customer_sk
     AND d_month_seq BETWEEN 1185 AND 1185 + 11
     AND c_birth_month IN (2,
                           3,
                           10,
                           12)
     AND cs_list_price BETWEEN 28 AND 87
     AND cs_wholesale_cost BETWEEN 80 AND 100 INTERSECT SELECT DISTINCT c_last_name,
                                                                             c_first_name,
                                                                             d_date
   FROM web_sales,
        date_dim,
        customer
   WHERE web_sales.ws_sold_date_sk = date_dim.d_date_sk
     AND web_sales.ws_bill_customer_sk = customer.c_customer_sk
     AND d_month_seq BETWEEN 1185 AND 1185 + 11
     AND c_birth_month IN (2,
                           3,
                           10,
                           12)
     AND ws_list_price BETWEEN 28 AND 87
     AND ws_wholesale_cost BETWEEN 80 AND 100) hot_cust
LIMIT 100;