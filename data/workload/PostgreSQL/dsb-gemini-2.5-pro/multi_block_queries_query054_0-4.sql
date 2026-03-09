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
  (SELECT DISTINCT c_customer_sk,
                   c_current_addr_sk
   FROM
     (SELECT c.c_customer_sk,
             c.c_current_addr_sk
      FROM catalog_sales cs
      JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
      JOIN item i ON cs.cs_item_sk = i.i_item_sk
      JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk
      WHERE d.d_moy = 7
        AND d.d_year = 1999
        AND i.i_category = 'Men'
        AND i.i_class = 'accessories'
        AND cs.cs_wholesale_cost BETWEEN 44 AND 74
        AND c.c_birth_year BETWEEN 1943 AND 1956
      UNION ALL SELECT c.c_customer_sk,
                       c.c_current_addr_sk
      FROM web_sales ws
      JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
      JOIN item i ON ws.ws_item_sk = i.i_item_sk
      JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
      WHERE d.d_moy = 7
        AND d.d_year = 1999
        AND i.i_category = 'Men'
        AND i.i_class = 'accessories'
        AND ws.ws_wholesale_cost BETWEEN 44 AND 74
        AND c.c_birth_year BETWEEN 1943 AND 1956) AS sales_customers),
     my_revenue AS
  (SELECT mc.c_customer_sk,
          sum(ss.ss_ext_sales_price) AS revenue
   FROM my_customers mc
   JOIN store_sales ss ON mc.c_customer_sk = ss.ss_customer_sk
   JOIN customer_address ca ON mc.c_current_addr_sk = ca.ca_address_sk
   JOIN store s ON ca.ca_county = s.s_county
   AND ca.ca_state = s.s_state
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
   GROUP BY mc.c_customer_sk)
SELECT cast(revenue/50 AS int) AS SEGMENT,
       count(*) AS num_customers,
       cast(revenue/50 AS int)*50 AS segment_base
FROM my_revenue
GROUP BY SEGMENT
ORDER BY SEGMENT,
         num_customers
LIMIT 100;