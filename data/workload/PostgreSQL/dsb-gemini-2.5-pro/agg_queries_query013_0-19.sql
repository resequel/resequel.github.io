
SELECT avg(ss_quantity),
       avg(ss_ext_sales_price),
       avg(ss_ext_wholesale_cost),
       sum(ss_ext_wholesale_cost)
FROM store_sales
JOIN store ON s_store_sk = ss_store_sk
WHERE EXISTS
    (SELECT 1
     FROM date_dim
     WHERE d_date_sk = ss_sold_date_sk
       AND d_year = 2001)
  AND ((EXISTS
          (SELECT 1
           FROM customer_demographics cd,
                household_demographics hd
           WHERE cd.cd_demo_sk = ss_cdemo_sk
             AND hd.hd_demo_sk = ss_hdemo_sk
             AND cd.cd_marital_status = 'U'
             AND cd.cd_education_status = 'College'
             AND ss_sales_price BETWEEN 100.00 AND 150.00
             AND hd.hd_dep_count = 3))
       OR (EXISTS
             (SELECT 1
              FROM customer_demographics cd,
                   household_demographics hd
              WHERE cd.cd_demo_sk = ss_cdemo_sk
                AND hd.hd_demo_sk = ss_hdemo_sk
                AND cd.cd_marital_status = 'W'
                AND cd.cd_education_status = '2 yr Degree'
                AND ss_sales_price BETWEEN 50.00 AND 100.00
                AND hd.hd_dep_count = 1))
       OR (EXISTS
             (SELECT 1
              FROM customer_demographics cd,
                   household_demographics hd
              WHERE cd.cd_demo_sk = ss_cdemo_sk
                AND hd.hd_demo_sk = ss_hdemo_sk
                AND cd.cd_marital_status = 'S'
                AND cd.cd_education_status = 'College'
                AND ss_sales_price BETWEEN 150.00 AND 200.00
                AND hd.hd_dep_count = 1)))
  AND ((EXISTS
          (SELECT 1
           FROM customer_address ca
           WHERE ca.ca_address_sk = ss_addr_sk
             AND ca.ca_country = 'United States'
             AND ca.ca_state IN ('IN', 'NM', 'VA')
             AND ss_net_profit BETWEEN 100 AND 200))
       OR (EXISTS
             (SELECT 1
              FROM customer_address ca
              WHERE ca.ca_address_sk = ss_addr_sk
                AND ca.ca_country = 'United States'
                AND ca.ca_state IN ('MT', 'OH', 'OR')
                AND ss_net_profit BETWEEN 150 AND 300))
       OR (EXISTS
             (SELECT 1
              FROM customer_address ca
              WHERE ca.ca_address_sk = ss_addr_sk
                AND ca.ca_country = 'United States'
                AND ca.ca_state IN ('GA', 'IL', 'TX')
                AND ss_net_profit BETWEEN 50 AND 250)));