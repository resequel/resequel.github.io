WITH demo_filtered AS
  (SELECT ss_item_sk,
          ss_ticket_number
   FROM store_sales
   JOIN customer_demographics ON ss_cdemo_sk = cd_demo_sk
   JOIN household_demographics ON ss_hdemo_sk = hd_demo_sk
   WHERE (cd_marital_status = 'U'
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
         AND hd_dep_count = 1)),
     addr_filtered AS
  (SELECT ss_item_sk,
          ss_ticket_number
   FROM store_sales
   JOIN customer_address ON ss_addr_sk = ca_address_sk
   WHERE (ca_country = 'United States'
          AND ca_state IN ('IN', 'NM', 'VA')
          AND ss_net_profit BETWEEN 100 AND 200)
     OR (ca_country = 'United States'
         AND ca_state IN ('MT', 'OH', 'OR')
         AND ss_net_profit BETWEEN 150 AND 300)
     OR (ca_country = 'United States'
         AND ca_state IN ('GA', 'IL', 'TX')
         AND ss_net_profit BETWEEN 50 AND 250))
SELECT avg(ss.ss_quantity),
       avg(ss.ss_ext_sales_price),
       avg(ss.ss_ext_wholesale_cost),
       sum(ss.ss_ext_wholesale_cost)
FROM store_sales ss
JOIN store s ON ss.s_store_sk = s.s_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN demo_filtered df ON ss.ss_item_sk = df.ss_item_sk
AND ss.ss_ticket_number = df.ss_ticket_number
JOIN addr_filtered af ON ss.ss_item_sk = af.ss_item_sk
AND ss.ss_ticket_number = af.ss_ticket_number
WHERE d.d_year = 2001;