WITH store_customers AS
  (SELECT DISTINCT ss_customer_sk AS customer_sk
   FROM store_sales
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   JOIN item ON ss_item_sk = i_item_sk
   WHERE d_year = 2001
     AND d_moy BETWEEN 1 AND 1 + 3
     AND i_category IN ('Books',
                          'Home',
                          'Sports')
     AND i_manager_id BETWEEN 91 AND 100
     AND ss_list_price > 0
     AND (ss_sales_price / ss_list_price) BETWEEN 17 * 0.01 AND 27 * 0.01),
     web_or_catalog_customers AS
  (SELECT DISTINCT customer_sk
   FROM
     (SELECT ws_bill_customer_sk AS customer_sk
      FROM web_sales
      JOIN date_dim ON ws_sold_date_sk = d_date_sk
      JOIN item ON ws_item_sk = i_item_sk
      WHERE d_year = 2001
        AND d_moy BETWEEN 1 AND 1 + 3
        AND i_category IN ('Books',
                               'Home',
                               'Sports')
        AND i_manager_id BETWEEN 91 AND 100
        AND ws_list_price > 0
        AND (ws_sales_price / ws_list_price) BETWEEN 17 * 0.01 AND 27 * 0.01
      UNION ALL SELECT cs_ship_customer_sk AS customer_sk
      FROM catalog_sales
      JOIN date_dim ON cs_sold_date_sk = d_date_sk
      JOIN item ON cs_item_sk = i_item_sk
      WHERE d_year = 2001
        AND d_moy BETWEEN 1 AND 1 + 3
        AND i_category IN ('Books',
                               'Home',
                               'Sports')
        AND i_manager_id BETWEEN 91 AND 100
        AND cs_list_price > 0
        AND (cs_sales_price / cs_list_price) BETWEEN 17 * 0.01 AND 27 * 0.01) AS all_web_catalog)
SELECT cd_gender,
       cd_marital_status,
       cd_education_status,
       count(*) cnt1,
       cd_purchase_estimate,
       count(*) cnt2,
       cd_credit_rating,
       count(*) cnt3,
       cd_dep_count,
       count(*) cnt4,
       cd_dep_employed_count,
       count(*) cnt5,
       cd_dep_college_count,
       count(*) cnt6
FROM customer c
JOIN store_customers sc ON c.c_customer_sk = sc.customer_sk
JOIN web_or_catalog_customers wocc ON c.c_customer_sk = wocc.customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
WHERE ca_county IN ('Audubon County',
                    'Dade County',
                    'Dewey County',
                    'Hardeman County',
                    'Talbot County')
  AND c.c_birth_month IN (4,
                          5)
  AND cd_marital_status IN ('M',
                            'U',
                            'U')
  AND cd_education_status IN ('Primary',
                              'College',
                              '4 yr Degree')
  AND cd_gender = 'M'
GROUP BY cd_gender,
         cd_marital_status,
         cd_education_status,
         cd_purchase_estimate,
         cd_credit_rating,
         cd_dep_count,
         cd_dep_employed_count,
         cd_dep_college_count
ORDER BY cd_gender,
         cd_marital_status,
         cd_education_status,
         cd_purchase_estimate,
         cd_credit_rating,
         cd_dep_count,
         cd_dep_employed_count,
         cd_dep_college_count
LIMIT 100;