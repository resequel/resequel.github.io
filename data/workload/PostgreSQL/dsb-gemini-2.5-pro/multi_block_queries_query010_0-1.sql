WITH d_store AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 2001
     AND d_moy BETWEEN 1 AND 1 + 3),
     i_store AS
  (SELECT i_item_sk
   FROM item
   WHERE i_category IN ('Books',
                          'Home',
                          'Sports')
     AND i_manager_id BETWEEN 91 AND 100),
     d_web AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 2001
     AND d_moy BETWEEN 1 AND 1 + 3),
     i_web AS
  (SELECT i_item_sk
   FROM item
   WHERE i_category IN ('Books',
                               'Home',
                               'Sports')
     AND i_manager_id BETWEEN 91 AND 100),
     d_catalog AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 2001
     AND d_moy BETWEEN 1 AND 1 + 3),
     i_catalog AS
  (SELECT i_item_sk
   FROM item
   WHERE i_category IN ('Books',
                               'Home',
                               'Sports')
     AND i_manager_id BETWEEN 91 AND 100)
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
  AND ca_county IN ('Audubon County',
                    'Dade County',
                    'Dewey County',
                    'Hardeman County',
                    'Talbot County')
  AND c.c_birth_month IN (4,
                          5)
  AND cd_demo_sk = c.c_current_cdemo_sk
  AND cd_marital_status IN ('M',
                            'U',
                            'U')
  AND cd_education_status IN ('Primary',
                              'College',
                              '4 yr Degree')
  AND cd_gender = 'M'
  AND EXISTS
    (SELECT 1
     FROM store_sales ss,
          d_store d,
          i_store i
     WHERE c.c_customer_sk = ss.ss_customer_sk
       AND ss.ss_sold_date_sk = d.d_date_sk
       AND ss.ss_item_sk = i.i_item_sk
       AND ss.ss_list_price > 0
       AND (ss.ss_sales_price / ss.ss_list_price) BETWEEN 17 * 0.01 AND 27 * 0.01)
  AND (EXISTS
         (SELECT 1
          FROM web_sales ws,
               d_web d,
               i_web i
          WHERE c.c_customer_sk = ws.ws_bill_customer_sk
            AND ws.ws_sold_date_sk = d.d_date_sk
            AND ws.ws_item_sk = i.i_item_sk
            AND ws.ws_list_price > 0
            AND (ws.ws_sales_price / ws.ws_list_price) BETWEEN 17 * 0.01 AND 27 * 0.01)
       OR EXISTS
         (SELECT 1
          FROM catalog_sales cs,
               d_catalog d,
               i_catalog i
          WHERE c.c_customer_sk = cs.cs_ship_customer_sk
            AND cs.cs_sold_date_sk = d.d_date_sk
            AND cs.cs_item_sk = i.i_item_sk
            AND cs.cs_list_price > 0
            AND (cs.cs_sales_price / cs.cs_list_price) BETWEEN 17 * 0.01 AND 27 * 0.01))
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