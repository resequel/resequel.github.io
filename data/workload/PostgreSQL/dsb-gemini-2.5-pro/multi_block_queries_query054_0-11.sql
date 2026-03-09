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
     (SELECT cs_sold_date_sk sold_date_sk,
             cs_bill_customer_sk customer_sk,
             cs_item_sk item_sk,
             cs_wholesale_cost wholesale_cost
      FROM catalog_sales
      UNION ALL SELECT ws_sold_date_sk sold_date_sk,
                       ws_bill_customer_sk customer_sk,
                       ws_item_sk item_sk,
                       ws_wholesale_cost wholesale_cost
      FROM web_sales) cs_or_ws_sales,
        item,
        date_dim,
        customer
   WHERE sold_date_sk = d_date_sk
     AND item_sk = i_item_sk
     AND i_category = 'Men'
     AND i_class = 'accessories'
     AND c_customer_sk = cs_or_ws_sales.customer_sk
     AND d_moy = 7
     AND d_year = 1999
     AND wholesale_cost BETWEEN 44 AND 74
     AND c_birth_year BETWEEN 1943 AND 1956),
     my_revenue AS
  (SELECT c_customer_sk,
          sum(ss_ext_sales_price) AS revenue
   FROM my_customers,
        store_sales,
        customer_address,
        store,
        date_dim,
        date_params
   WHERE c_current_addr_sk = ca_address_sk
     AND ca_county = s_county
     AND ca_state = s_state
     AND ss_sold_date_sk = d_date_sk
     AND c_customer_sk = ss_customer_sk
     AND ss_wholesale_cost BETWEEN 44 AND 74
     AND s_state IN ('GA',
                     'IL',
                     'IN',
                     'MT',
                     'NC',
                     'NM',
                     'OH',
                     'OR',
                     'TX',
                     'VA')
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