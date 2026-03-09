WITH my_customers AS
  (SELECT DISTINCT c.c_customer_sk,
                   c.c_current_addr_sk
   FROM catalog_sales cs
   JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
   AND d.d_year = 1999
   AND d.d_moy = 7
   JOIN item i ON cs.cs_item_sk = i.i_item_sk
   AND i.i_category = 'Men'
   AND i.i_class = 'accessories'
   JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk
   AND c.c_birth_year BETWEEN 1943 AND 1956
   WHERE cs.cs_wholesale_cost BETWEEN 44 AND 74)
SELECT CAST((revenue / 50) AS INT) AS SEGMENT,
       COUNT(*) AS num_customers,
       CAST((revenue / 50) AS INT) * 50 AS segment_base
FROM
  (SELECT SUM(ss.ss_ext_sales_price) AS revenue
   FROM my_customers mc
   JOIN store_sales ss ON mc.c_customer_sk = ss.ss_customer_sk
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN customer_address ca ON mc.c_current_addr_sk = ca.ca_address_sk
   JOIN store s ON ca.ca_county = s.s_county
   AND ca.ca_state = s.s_state
   WHERE ss.ss_wholesale_cost BETWEEN 44 AND 74
     AND s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NC',
                     'NM',
                     'OH',
                     'OR',
                     'TX',
                     'VA')
     AND d.d_month_seq BETWEEN
       (SELECT d_month_seq
        FROM date_dim
        WHERE d_year = 1999
          AND d_moy = 7) + 1 AND
       (SELECT d_month_seq
        FROM date_dim
        WHERE d_year = 1999
          AND d_moy = 7) + 3
   GROUP BY mc.c_customer_sk) my_revenue
GROUP BY SEGMENT
ORDER BY SEGMENT,
         num_customers
LIMIT 100;