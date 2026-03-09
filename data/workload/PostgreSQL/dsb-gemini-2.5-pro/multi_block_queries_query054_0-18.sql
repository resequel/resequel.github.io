WITH my_customers AS
  (SELECT DISTINCT cs.cs_bill_customer_sk AS c_customer_sk,
                   c.c_current_addr_sk
   FROM catalog_sales cs
   JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk
   WHERE c.c_birth_year BETWEEN 1943 AND 1956
     AND cs.cs_wholesale_cost BETWEEN 44 AND 74
     AND cs.cs_item_sk IN
       (SELECT i_item_sk
        FROM item
        WHERE i_category = 'Men'
          AND i_class = 'accessories')
     AND cs.cs_sold_date_sk IN
       (SELECT d_date_sk
        FROM date_dim
        WHERE d_year = 1999
          AND d_moy = 7)),
     my_revenue AS
  (SELECT mc.c_customer_sk,
          SUM(ss.ss_ext_sales_price) AS revenue
   FROM my_customers mc
   JOIN store_sales ss ON mc.c_customer_sk = ss.ss_customer_sk
   WHERE ss.ss_wholesale_cost BETWEEN 44 AND 74
     AND mc.c_current_addr_sk IN
       (SELECT ca_address_sk
        FROM customer_address ca
        JOIN store s ON ca.ca_county = s.s_county
        AND ca.ca_state = s.s_state
        WHERE s.s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NC',
                     'NM',
                     'OH',
                     'OR',
                     'TX',
                     'VA'))
     AND ss.ss_sold_date_sk IN
       (SELECT d_date_sk
        FROM date_dim
        WHERE d_month_seq BETWEEN
            (SELECT d_month_seq
             FROM date_dim
             WHERE d_year = 1999
               AND d_moy = 7) + 1 AND
            (SELECT d_month_seq
             FROM date_dim
             WHERE d_year = 1999
               AND d_moy = 7) + 3)
   GROUP BY mc.c_customer_sk),
     segments AS
  (SELECT CAST((revenue / 50) AS INT) AS SEGMENT
   FROM my_revenue)
SELECT SEGMENT,
       COUNT(*) AS num_customers,
       SEGMENT * 50 AS segment_base
FROM segments
GROUP BY SEGMENT
ORDER BY SEGMENT,
         num_customers
LIMIT 100;