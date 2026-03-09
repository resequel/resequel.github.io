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
     (SELECT cs_sold_date_sk sold_date_sk,
             cs_bill_customer_sk customer_sk,
             cs_item_sk item_sk,
             cs_wholesale_cost wholesale_cost
      FROM catalog_sales
      UNION ALL SELECT ws_sold_date_sk,
                       ws_bill_customer_sk,
                       ws_item_sk,
                       ws_wholesale_cost
      FROM web_sales) cs_or_ws_sales
   JOIN date_dim ON sold_date_sk = d_date_sk
   JOIN item ON item_sk = i_item_sk
   JOIN customer c ON customer_sk = c.c_customer_sk
   WHERE i_category = 'Men'
     AND i_class = 'accessories'
     AND d_moy = 7
     AND d_year = 1999
     AND wholesale_cost BETWEEN 44 AND 74
     AND c_birth_year BETWEEN 1943 AND 1956),
     my_revenue AS
  (SELECT c_customer_sk,
          sum(ss_ext_sales_price) AS revenue
   FROM my_customers
   JOIN store_sales ON c_customer_sk = ss_customer_sk
   JOIN customer_address ON c_current_addr_sk = ca_address_sk
   JOIN store ON ca_county = s_county
   AND ca_state = s_state
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   CROSS JOIN date_params
   WHERE s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NC',
                     'NM',
                     'OH',
                     'OR',
                     'TX',
                     'VA')
     AND ss_wholesale_cost BETWEEN 44 AND 74
     AND d_month_seq BETWEEN date_params.start_seq AND date_params.end_seq
   GROUP BY c_customer_sk)
SELECT cast((revenue/50) AS int) AS SEGMENT,
       count(*) AS num_customers,
       cast((revenue/50) AS int)*50 AS segment_base
FROM my_revenue
GROUP BY SEGMENT
ORDER BY SEGMENT,
         num_customers
LIMIT 100;