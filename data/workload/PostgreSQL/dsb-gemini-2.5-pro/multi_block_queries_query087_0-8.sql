WITH filtered_ss AS
  (SELECT ss_sold_date_sk,
          ss_customer_sk
   FROM store_sales
   WHERE ss_list_price BETWEEN 269 AND 298
     AND ss_wholesale_cost BETWEEN 90 AND 100),
     filtered_cs AS
  (SELECT cs_sold_date_sk,
          cs_bill_customer_sk
   FROM catalog_sales
   WHERE cs_list_price BETWEEN 269 AND 298
     AND cs_wholesale_cost BETWEEN 90 AND 100),
     filtered_ws AS
  (SELECT ws_sold_date_sk,
          ws_bill_customer_sk
   FROM web_sales
   WHERE ws_list_price BETWEEN 269 AND 298
     AND ws_wholesale_cost BETWEEN 90 AND 100)
SELECT count(*)
FROM
  (SELECT DISTINCT c_last_name,
                   c_first_name,
                   d_date
   FROM filtered_ss
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   JOIN customer ON ss_customer_sk = c_customer_sk
   WHERE d_month_seq BETWEEN 1222 AND 1222+11
     AND c_birth_year BETWEEN 1958 AND 1964
   EXCEPT SELECT DISTINCT c_last_name,
                          c_first_name,
                          d_date
   FROM filtered_cs
   JOIN date_dim ON cs_sold_date_sk = d_date_sk
   JOIN customer ON cs_bill_customer_sk = c_customer_sk
   WHERE d_month_seq BETWEEN 1222 AND 1222+11
     AND c_birth_year BETWEEN 1958 AND 1964
   EXCEPT SELECT DISTINCT c_last_name,
                          c_first_name,
                          d_date
   FROM filtered_ws
   JOIN date_dim ON ws_sold_date_sk = d_date_sk
   JOIN customer ON ws_bill_customer_sk = c_customer_sk
   WHERE d_month_seq BETWEEN 1222 AND 1222+11
     AND c_birth_year BETWEEN 1958 AND 1964) cool_cust;