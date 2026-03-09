WITH store_customers AS
  (SELECT DISTINCT ss_customer_sk
   FROM store_sales
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   WHERE d_year = 2000
     AND d_moy BETWEEN 9 AND 9 + 2
     AND ss_list_price BETWEEN 5 AND 94)
SELECT cd.cd_gender,
       cd.cd_marital_status,
       cd.cd_education_status,
       cd.cd_purchase_estimate,
       cd.cd_credit_rating,
       count(*) AS cnt
FROM customer c
JOIN store_customers sc ON c.c_customer_sk = sc.ss_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
WHERE ca.ca_state IN ('IN',
                   'NM',
                   'VA')
  AND cd.cd_marital_status IN ('W',
                            'S',
                            'M')
  AND cd.cd_education_status IN ('Secondary',
                              'Primary')
  AND NOT EXISTS
    (SELECT 1
     FROM web_sales,
          date_dim
     WHERE c.c_customer_sk = ws_bill_customer_sk
       AND ws_sold_date_sk = d_date_sk
       AND d_year = 2000
       AND d_moy BETWEEN 9 AND 9 + 2
       AND ws_list_price BETWEEN 5 AND 94)
  AND NOT EXISTS
    (SELECT 1
     FROM catalog_sales,
          date_dim
     WHERE c.c_customer_sk = cs_ship_customer_sk
       AND cs_sold_date_sk = d_date_sk
       AND d_year = 2000
       AND d_moy BETWEEN 9 AND 9 + 2
       AND cs_list_price BETWEEN 5 AND 94)
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