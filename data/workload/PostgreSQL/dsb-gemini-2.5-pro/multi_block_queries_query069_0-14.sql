WITH qualified_customers AS
  (SELECT c.c_customer_sk,
          cd.cd_gender,
          cd.cd_marital_status,
          cd.cd_education_status,
          cd.cd_purchase_estimate,
          cd.cd_credit_rating
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
                              'Primary'))
SELECT qc.cd_gender,
       qc.cd_marital_status,
       qc.cd_education_status,
       qc.cd_purchase_estimate,
       qc.cd_credit_rating,
       count(*) AS cnt
FROM qualified_customers qc
WHERE EXISTS
    (SELECT 1
     FROM store_sales,
          date_dim
     WHERE qc.c_customer_sk = ss_customer_sk
       AND ss_sold_date_sk = d_date_sk
       AND d_year = 2000
       AND d_moy BETWEEN 9 AND 9 + 2
       AND ss_list_price BETWEEN 5 AND 94)
  AND NOT EXISTS
    (SELECT 1
     FROM web_sales,
          date_dim
     WHERE qc.c_customer_sk = ws_bill_customer_sk
       AND ws_sold_date_sk = d_date_sk
       AND d_year = 2000
       AND d_moy BETWEEN 9 AND 9 + 2
       AND ws_list_price BETWEEN 5 AND 94)
  AND NOT EXISTS
    (SELECT 1
     FROM catalog_sales,
          date_dim
     WHERE qc.c_customer_sk = cs_ship_customer_sk
       AND cs_sold_date_sk = d_date_sk
       AND d_year = 2000
       AND d_moy BETWEEN 9 AND 9 + 2
       AND cs_list_price BETWEEN 5 AND 94)
GROUP BY qc.cd_gender,
         qc.cd_marital_status,
         qc.cd_education_status,
         qc.cd_purchase_estimate,
         qc.cd_credit_rating
ORDER BY qc.cd_gender,
         qc.cd_marital_status,
         qc.cd_education_status,
         qc.cd_purchase_estimate,
         qc.cd_credit_rating
LIMIT 100;