WITH d_keys AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 2001),
     cd_keys AS
  (SELECT cd_demo_sk,
          'g1' AS grp
   FROM customer_demographics
   WHERE cd_marital_status = 'U'
     AND cd_education_status = 'College'
   UNION ALL SELECT cd_demo_sk,
                    'g2' AS grp
   FROM customer_demographics
   WHERE cd_marital_status = 'W'
     AND cd_education_status = '2 yr Degree'
   UNION ALL SELECT cd_demo_sk,
                    'g3' AS grp
   FROM customer_demographics
   WHERE cd_marital_status = 'S'
     AND cd_education_status = 'College'),
     hd_keys AS
  (SELECT hd_demo_sk,
          'g1' AS grp
   FROM household_demographics
   WHERE hd_dep_count = 3
   UNION ALL SELECT hd_demo_sk,
                    'g2' AS grp
   FROM household_demographics
   WHERE hd_dep_count = 1
   UNION ALL SELECT hd_demo_sk,
                    'g3' AS grp
   FROM household_demographics
   WHERE hd_dep_count = 1),
     ca_keys AS
  (SELECT ca_address_sk,
          'ga' AS grp
   FROM customer_address
   WHERE ca_country = 'United States'
     AND ca_state IN (('IN', 'NM', 'VA'))
   UNION ALL SELECT ca_address_sk,
                    'gb' AS grp
   FROM customer_address
   WHERE ca_country = 'United States'
     AND ca_state IN (('MT', 'OH', 'OR'))
   UNION ALL SELECT ca_address_sk,
                    'gc' AS grp
   FROM customer_address
   WHERE ca_country = 'United States'
     AND ca_state IN (('GA', 'IL', 'TX')))
SELECT min(ss_quantity),
       min(ss_ext_sales_price),
       min(ss_ext_wholesale_cost)
FROM store_sales
JOIN store ON s_store_sk = ss_store_sk
JOIN d_keys ON ss_sold_date_sk = d_keys.d_date_sk
JOIN cd_keys ON ss_cdemo_sk = cd_keys.cd_demo_sk
JOIN hd_keys ON ss_hdemo_sk = hd_keys.hd_demo_sk
JOIN ca_keys ON ss_addr_sk = ca_keys.ca_address_sk
WHERE cd_keys.grp = hd_keys.grp
  AND ((cd_keys.grp = 'g1'
        AND ss_sales_price BETWEEN 100.00 AND 150.00)
       OR (cd_keys.grp = 'g2'
           AND ss_sales_price BETWEEN 50.00 AND 100.00)
       OR (cd_keys.grp = 'g3'
           AND ss_sales_price BETWEEN 150.00 AND 200.00))
  AND ((ca_keys.grp = 'ga'
        AND ss_net_profit BETWEEN 100 AND 200)
       OR (ca_keys.grp = 'gb'
           AND ss_net_profit BETWEEN 150 AND 300)
       OR (ca_keys.grp = 'gc'
           AND ss_net_profit BETWEEN 50 AND 250));