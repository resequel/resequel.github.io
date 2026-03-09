
SELECT cd_gender,
       cd_marital_status,
       cd_education_status,
       count(*) cnt1,
       cd_purchase_estimate,
       count(*) cnt2,
       cd_credit_rating,
       count(*) cnt3
FROM customer c
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
JOIN
  (SELECT DISTINCT ss_customer_sk
   FROM store_sales
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   WHERE d_year = 2000
     AND d_moy BETWEEN 9 AND 9 + 2
     AND ss_list_price BETWEEN 5 AND 94) ss ON c.c_customer_sk = ss.ss_customer_sk
LEFT JOIN
  (SELECT DISTINCT ws_bill_customer_sk
   FROM web_sales
   JOIN date_dim ON ws_sold_date_sk = d_date_sk
   WHERE d_year = 2000
     AND d_moy BETWEEN 9 AND 9 + 2
     AND ws_list_price BETWEEN 5 AND 94) ws ON c.c_customer_sk = ws.ws_bill_customer_sk
LEFT JOIN
  (SELECT DISTINCT cs_ship_customer_sk
   FROM catalog_sales
   JOIN date_dim ON cs_sold_date_sk = d_date_sk
   WHERE d_year = 2000
     AND d_moy BETWEEN 9 AND 9 + 2
     AND cs_list_price BETWEEN 5 AND 94) cs ON c.c_customer_sk = cs.cs_ship_customer_sk
WHERE ca.ca_state IN ('IN',
                   'NM',
                   'VA')
  AND cd.cd_marital_status IN ('W',
                            'S',
                            'M')
  AND cd.cd_education_status IN ('Secondary',
                              'Primary')
  AND ws.ws_bill_customer_sk IS NULL
  AND cs.cs_ship_customer_sk IS NULL
GROUP BY cd_gender,
         cd_marital_status,
         cd_education_status,
         cd_purchase_estimate,
         cd_credit_rating
ORDER BY cd_gender,
         cd_marital_status,
         cd_education_status,
         cd_purchase_estimate,
         cd_credit_rating
LIMIT 100;