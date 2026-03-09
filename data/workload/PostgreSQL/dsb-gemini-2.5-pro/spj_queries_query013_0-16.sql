
SELECT min(ss_quantity),
       min(ss_ext_sales_price),
       min(ss_ext_wholesale_cost)
FROM store_sales,
     store,
     date_dim
WHERE s_store_sk = ss_store_sk
  AND ss_sold_date_sk = d_date_sk
  AND d_year = 2001
  AND ((ss_hdemo_sk IN
          (SELECT hd_demo_sk
           FROM household_demographics
           WHERE hd_dep_count = 3)
        AND ss_cdemo_sk IN
          (SELECT cd_demo_sk
           FROM customer_demographics
           WHERE cd_marital_status = 'U'
             AND cd_education_status = 'College')
        AND ss_sales_price BETWEEN 100.00 AND 150.00)
       OR (ss_hdemo_sk IN
             (SELECT hd_demo_sk
              FROM household_demographics
              WHERE hd_dep_count = 1)
           AND ss_cdemo_sk IN
             (SELECT cd_demo_sk
              FROM customer_demographics
              WHERE cd_marital_status = 'W'
                AND cd_education_status = '2 yr Degree')
           AND ss_sales_price BETWEEN 50.00 AND 100.00)
       OR (ss_hdemo_sk IN
             (SELECT hd_demo_sk
              FROM household_demographics
              WHERE hd_dep_count = 1)
           AND ss_cdemo_sk IN
             (SELECT cd_demo_sk
              FROM customer_demographics
              WHERE cd_marital_status = 'S'
                AND cd_education_status = 'College')
           AND ss_sales_price BETWEEN 150.00 AND 200.00))
  AND ((ss_addr_sk IN
          (SELECT ca_address_sk
           FROM customer_address
           WHERE ca_country = 'United States'
             AND ca_state IN (('IN', 'NM', 'VA')))
        AND ss_net_profit BETWEEN 100 AND 200)
       OR (ss_addr_sk IN
             (SELECT ca_address_sk
              FROM customer_address
              WHERE ca_country = 'United States'
                AND ca_state IN (('MT', 'OH', 'OR')))
           AND ss_net_profit BETWEEN 150 AND 300)
       OR (ss_addr_sk IN
             (SELECT ca_address_sk
              FROM customer_address
              WHERE ca_country = 'United States'
                AND ca_state IN (('GA', 'IL', 'TX')))
           AND ss_net_profit BETWEEN 50 AND 250));