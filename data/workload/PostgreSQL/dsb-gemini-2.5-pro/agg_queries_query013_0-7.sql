WITH date_filtered AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 2001),
     demo_filtered AS
  (SELECT cd_demo_sk,
          hd_demo_sk
   FROM customer_demographics,
        household_demographics
   WHERE (cd_marital_status = 'U'
          AND cd_education_status = 'College'
          AND hd_dep_count = 3)
     OR (cd_marital_status = 'W'
         AND cd_education_status = '2 yr Degree'
         AND hd_dep_count = 1)
     OR (cd_marital_status = 'S'
         AND cd_education_status = 'College'
         AND hd_dep_count = 1)),
     addr_filtered AS
  (SELECT ca_address_sk
   FROM customer_address
   WHERE (ca_country = 'United States'
          AND ca_state IN ('IN', 'NM', 'VA'))
     OR (ca_country = 'United States'
         AND ca_state IN ('MT', 'OH', 'OR'))
     OR (ca_country = 'United States'
         AND ca_state IN ('GA', 'IL', 'TX')))
SELECT avg(ss_quantity),
       avg(ss_ext_sales_price),
       avg(ss_ext_wholesale_cost),
       sum(ss_ext_wholesale_cost)
FROM store_sales
JOIN store ON s_store_sk = ss_store_sk
JOIN date_filtered ON ss_sold_date_sk = d_date_sk
JOIN demo_filtered ON ss_cdemo_sk = cd_demo_sk
AND ss_hdemo_sk = hd_demo_sk
JOIN addr_filtered ON ss_addr_sk = ca_address_sk
WHERE ((ss_sales_price BETWEEN 100.00 AND 150.00
        AND ss_net_profit BETWEEN 100 AND 200)
       OR (ss_sales_price BETWEEN 50.00 AND 100.00
           AND ss_net_profit BETWEEN 150 AND 300)
       OR (ss_sales_price BETWEEN 150.00 AND 200.00
           AND ss_net_profit BETWEEN 50 AND 250));