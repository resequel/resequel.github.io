
SELECT count(*)
FROM
  (SELECT c_last_name,
          c_first_name,
          d_date
   FROM
     (SELECT c.c_last_name,
             c.c_first_name,
             d.d_date,
             'store' AS channel
      FROM store_sales
      JOIN date_dim d ON ss_sold_date_sk = d.d_date_sk
      JOIN customer c ON ss_customer_sk = c.c_customer_sk
      WHERE d.d_month_seq BETWEEN 1222 AND 1222+11
        AND ss_list_price BETWEEN 269 AND 298
        AND c.c_birth_year BETWEEN 1958 AND 1964
        AND ss_wholesale_cost BETWEEN 90 AND 100
      UNION ALL SELECT c.c_last_name,
                       c.c_first_name,
                       d.d_date,
                       'catalog'
      FROM catalog_sales
      JOIN date_dim d ON cs_sold_date_sk = d.d_date_sk
      JOIN customer c ON cs_bill_customer_sk = c.c_customer_sk
      WHERE d.d_month_seq BETWEEN 1222 AND 1222+11
        AND cs_list_price BETWEEN 269 AND 298
        AND c.c_birth_year BETWEEN 1958 AND 1964
        AND cs_wholesale_cost BETWEEN 90 AND 100
      UNION ALL SELECT c.c_last_name,
                       c.c_first_name,
                       d.d_date,
                       'web'
      FROM web_sales
      JOIN date_dim d ON ws_sold_date_sk = d.d_date_sk
      JOIN customer c ON ws_bill_customer_sk = c.c_customer_sk
      WHERE d.d_month_seq BETWEEN 1222 AND 1222+11
        AND ws_list_price BETWEEN 269 AND 298
        AND c.c_birth_year BETWEEN 1958 AND 1964
        AND ws_wholesale_cost BETWEEN 90 AND 100) all_sales
   GROUP BY c_last_name,
            c_first_name,
            d_date
   HAVING count(DISTINCT channel) = 1
   AND max(channel) = 'store') cool_cust;