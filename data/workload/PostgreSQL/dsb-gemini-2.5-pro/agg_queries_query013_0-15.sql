WITH cd_filtered AS
  (SELECT cd_demo_sk,
          cd_marital_status,
          cd_education_status
   FROM customer_demographics
   WHERE cd_marital_status IN ('U', 'W', 'S')
     AND cd_education_status IN ('College', '2 yr Degree', 'College')),
     hd_filtered AS
  (SELECT hd_demo_sk,
          hd_dep_count
   FROM household_demographics
   WHERE hd_dep_count IN (3, 1, 1)),
     ca_filtered AS
  (SELECT ca_address_sk,
          ca_country,
          ca_state
   FROM customer_address
   WHERE ca_country IN ('United States', 'United States', 'United States'))
SELECT avg(ss_quantity),
       avg(ss_ext_sales_price),
       avg(ss_ext_wholesale_cost),
       sum(ss_ext_wholesale_cost)
FROM store_sales
JOIN store ON s_store_sk = ss_store_sk
JOIN date_dim ON ss_sold_date_sk = d_date_sk
AND d_year = 2001
JOIN cd_filtered ON ss_cdemo_sk = cd_filtered.cd_demo_sk
JOIN hd_filtered ON ss_hdemo_sk = hd_filtered.hd_demo_sk
JOIN ca_filtered ON ss_addr_sk = ca_filtered.ca_address_sk
WHERE ((cd_marital_status = 'U'
        AND cd_education_status = 'College'
        AND ss_sales_price BETWEEN 100.00 AND 150.00
        AND hd_dep_count = 3)
       OR (cd_marital_status = 'W'
           AND cd_education_status = '2 yr Degree'
           AND ss_sales_price BETWEEN 50.00 AND 100.00
           AND hd_dep_count = 1)
       OR (cd_marital_status = 'S'
           AND cd_education_status = 'College'
           AND ss_sales_price BETWEEN 150.00 AND 200.00
           AND hd_dep_count = 1))
  AND ((ca_country = 'United States'
        AND ca_state IN ('IN', 'NM', 'VA')
        AND ss_net_profit BETWEEN 100 AND 200)
       OR (ca_country = 'United States'
           AND ca_state IN ('MT', 'OH', 'OR')
           AND ss_net_profit BETWEEN 150 AND 300)
       OR (ca_country = 'United States'
           AND ca_state IN ('GA', 'IL', 'TX')
           AND ss_net_profit BETWEEN 50 AND 250));