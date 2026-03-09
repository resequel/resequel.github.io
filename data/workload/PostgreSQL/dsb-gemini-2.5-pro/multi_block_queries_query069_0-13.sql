WITH final_customers AS (
                           (SELECT c.c_customer_sk
                            FROM customer c
                            JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
                            JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
                            WHERE ca.ca_state IN ('IN',
                   'NM',
                   'VA')
                              AND cd.cd_marital_status IN ('W',
                            'S',
                            'M')
                              AND cd.cd_education_status IN ('Secondary',
                              'Primary')) INTERSECT
                           (SELECT ss_customer_sk
                            FROM store_sales,
                                 date_dim
                            WHERE ss_sold_date_sk = d_date_sk
                              AND d_year = 2000
                              AND d_moy BETWEEN 9 AND 9 + 2
                              AND ss_list_price BETWEEN 5 AND 94)
                         EXCEPT
                           (SELECT ws_bill_customer_sk
                            FROM web_sales,
                                 date_dim
                            WHERE ws_sold_date_sk = d_date_sk
                              AND d_year = 2000
                              AND d_moy BETWEEN 9 AND 9 + 2
                              AND ws_list_price BETWEEN 5 AND 94)
                         EXCEPT
                           (SELECT cs_ship_customer_sk
                            FROM catalog_sales,
                                 date_dim
                            WHERE cs_sold_date_sk = d_date_sk
                              AND d_year = 2000
                              AND d_moy BETWEEN 9 AND 9 + 2
                              AND cs_list_price BETWEEN 5 AND 94))
SELECT cd.cd_gender,
       cd.cd_marital_status,
       cd.cd_education_status,
       cd.cd_purchase_estimate,
       cd.cd_credit_rating,
       count(*) AS cnt
FROM final_customers fc
JOIN customer c ON fc.c_customer_sk = c.c_customer_sk
JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
GROUP BY cd.cd_gender,
         cd.cd_marital_status,
         cd.cd_education_status,
         cd.cd_purchase_estimate,
         cd.cd_credit_rating
ORDER BY cd.cd_gender,
         cd.cd_marital_status,
         cd.cd_education_status,
         cd.cd_purchase_estimate,
         cd.cd_credit_rating
LIMIT 100;