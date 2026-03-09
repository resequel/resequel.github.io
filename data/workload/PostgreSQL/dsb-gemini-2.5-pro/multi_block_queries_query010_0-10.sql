WITH store_customers AS
  (SELECT ss_customer_sk
   FROM store_sales,
        date_dim,
        item
   WHERE ss_sold_date_sk = d_date_sk
     AND ss_item_sk = i_item_sk
     AND d_year = 2001
     AND d_moy BETWEEN 1 AND 1 + 3
     AND i_category IN ('Books',
                          'Home',
                          'Sports')
     AND i_manager_id BETWEEN 91 AND 100
     AND ss_list_price > 0
     AND ss_sales_price / ss_list_price BETWEEN 17 * 0.01 AND 27 * 0.01),
     web_customers AS
  (SELECT ws_bill_customer_sk
   FROM web_sales,
        date_dim,
        item
   WHERE ws_sold_date_sk = d_date_sk
     AND ws_item_sk = i_item_sk
     AND d_year = 2001
     AND d_moy BETWEEN 1 AND 1 + 3
     AND i_category IN ('Books',
                               'Home',
                               'Sports')
     AND i_manager_id BETWEEN 91 AND 100
     AND ws_list_price > 0
     AND ws_sales_price / ws_list_price BETWEEN 17 * 0.01 AND 27 * 0.01),
     catalog_customers AS
  (SELECT cs_ship_customer_sk
   FROM catalog_sales,
        date_dim,
        item
   WHERE cs_sold_date_sk = d_date_sk
     AND cs_item_sk = i_item_sk
     AND d_year = 2001
     AND d_moy BETWEEN 1 AND 1 + 3
     AND i_category IN ('Books',
                               'Home',
                               'Sports')
     AND i_manager_id BETWEEN 91 AND 100
     AND cs_list_price > 0
     AND cs_sales_price / cs_list_price BETWEEN 17 * 0.01 AND 27 * 0.01)
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
FROM customer c,
     customer_address ca,
     customer_demographics
WHERE c.c_current_addr_sk = ca.ca_address_sk
  AND cd_demo_sk = c.c_current_cdemo_sk
  AND ca_county IN ('Audubon County',
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
  AND EXISTS
    (SELECT 1
     FROM store_customers sc
     WHERE sc.ss_customer_sk = c.c_customer_sk)
  AND (EXISTS
         (SELECT 1
          FROM web_customers wc
          WHERE wc.ws_bill_customer_sk = c.c_customer_sk)
       OR EXISTS
         (SELECT 1
          FROM catalog_customers cc
          WHERE cc.cs_ship_customer_sk = c.c_customer_sk))
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