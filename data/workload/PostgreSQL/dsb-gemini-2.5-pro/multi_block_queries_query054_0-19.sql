WITH date_params AS
  (SELECT
     (SELECT d_month_seq
      FROM date_dim
      WHERE d_year = 1999
        AND d_moy = 7) + 1 AS start_seq,
     (SELECT d_month_seq
      FROM date_dim
      WHERE d_year = 1999
        AND d_moy = 7) + 3 AS end_seq),
     my_customers AS
  (SELECT DISTINCT c.c_customer_sk,
                   c.c_current_addr_sk
   FROM
     (SELECT cs_bill_customer_sk AS customer_sk
      FROM catalog_sales
      JOIN date_dim ON cs_sold_date_sk = d_date_sk
      JOIN item ON cs_item_sk = i_item_sk
      WHERE d_moy = 7
        AND d_year = 1999
        AND i_category = 'Men'
        AND i_class = 'accessories'
        AND cs_wholesale_cost BETWEEN 44 AND 74
      UNION ALL SELECT ws_bill_customer_sk AS customer_sk
      FROM web_sales
      JOIN date_dim ON ws_sold_date_sk = d_date_sk
      JOIN item ON ws_item_sk = i_item_sk
      WHERE d_moy = 7
        AND d_year = 1999
        AND i_category = 'Men'
        AND i_class = 'accessories'
        AND ws_wholesale_cost BETWEEN 44 AND 74) sales
   JOIN customer c ON sales.customer_sk = c.c_customer_sk
   WHERE c.c_birth_year BETWEEN 1943 AND 1956)
SELECT cast(revenue/50 AS int) AS SEGMENT,
       count(*) AS num_customers,
       cast(revenue/50 AS int)*50 AS segment_base
FROM
  (SELECT mc.c_customer_sk,
          sum(ss.ss_ext_sales_price) AS revenue
   FROM store s
   JOIN customer_address ca ON s.s_county = ca.ca_county
   AND s.s_state = ca.ca_state
   JOIN my_customers mc ON ca.ca_address_sk = mc.c_current_addr_sk
   JOIN store_sales ss ON mc.c_customer_sk = ss.ss_customer_sk
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   CROSS JOIN date_params dp
   WHERE s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NC',
                     'NM',
                     'OH',
                     'OR',
                     'TX',
                     'VA')
     AND ss.ss_wholesale_cost BETWEEN 44 AND 74
     AND d.d_month_seq BETWEEN dp.start_seq AND dp.end_seq
   GROUP BY mc.c_customer_sk) my_revenue
GROUP BY SEGMENT
ORDER BY SEGMENT,
         num_customers
LIMIT 100;