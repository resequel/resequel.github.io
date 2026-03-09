WITH customer_sales_flags AS
  (SELECT c_customer_sk,
          max(is_ss) AS has_ss,
          max(is_ws) AS has_ws,
          max(is_cs) AS has_cs
   FROM
     (SELECT ss_customer_sk AS c_customer_sk,
             1 AS is_ss,
             0 AS is_ws,
             0 AS is_cs
      FROM store_sales
      JOIN date_dim ON ss_sold_date_sk = d_date_sk
      WHERE d_year = 2000
        AND d_moy BETWEEN 9 AND 9 + 2
        AND ss_list_price BETWEEN 5 AND 94
      UNION ALL SELECT ws_bill_customer_sk,
                       0,
                       1,
                       0
      FROM web_sales
      JOIN date_dim ON ws_sold_date_sk = d_date_sk
      WHERE d_year = 2000
        AND d_moy BETWEEN 9 AND 9 + 2
        AND ws_list_price BETWEEN 5 AND 94
      UNION ALL SELECT cs_ship_customer_sk,
                       0,
                       0,
                       1
      FROM catalog_sales
      JOIN date_dim ON cs_sold_date_sk = d_date_sk
      WHERE d_year = 2000
        AND d_moy BETWEEN 9 AND 9 + 2
        AND cs_list_price BETWEEN 5 AND 94) all_sales
   GROUP BY c_customer_sk)
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
JOIN customer_sales_flags sf ON c.c_customer_sk = sf.c_customer_sk
WHERE ca.ca_state IN ('IN',
                   'NM',
                   'VA')
  AND cd.cd_marital_status IN ('W',
                            'S',
                            'M')
  AND cd.cd_education_status IN ('Secondary',
                              'Primary')
  AND sf.has_ss = 1
  AND sf.has_ws = 0
  AND sf.has_cs = 0
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