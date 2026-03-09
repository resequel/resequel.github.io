WITH filtered_sales AS
  (SELECT cs.cs_item_sk,
          cs.cs_bill_cdemo_sk,
          cs.cs_bill_customer_sk,
          cs.cs_quantity,
          cs.cs_list_price,
          cs.cs_coupon_amt,
          cs.cs_sales_price,
          cs.cs_net_profit
   FROM catalog_sales cs
   JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
   WHERE d.d_year = 2001
     AND cs.cs_wholesale_cost BETWEEN 84 AND 89),
     filtered_item AS
  (SELECT i_item_sk,
          i_item_id
   FROM item
   WHERE i_category = 'Jewelry'),
     filtered_cdemo AS
  (SELECT cd_demo_sk
   FROM customer_demographics
   WHERE cd_gender = 'F'
     AND cd_education_status = 'College'),
     filtered_cust_addr AS
  (SELECT c.c_customer_sk,
          c.c_birth_year,
          ca.ca_country,
          ca.ca_state,
          ca.ca_county
   FROM customer c
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   WHERE c.c_birth_month = 5
     AND ca.ca_state IN ('MT',
                   'OH',
                   'OR'))
SELECT i.i_item_id,
       fca.ca_country,
       fca.ca_state,
       fca.ca_county,
       avg(cast(fs.cs_quantity AS decimal(12, 2))) agg1,
       avg(cast(fs.cs_list_price AS decimal(12, 2))) agg2,
       avg(cast(fs.cs_coupon_amt AS decimal(12, 2))) agg3,
       avg(cast(fs.cs_sales_price AS decimal(12, 2))) agg4,
       avg(cast(fs.cs_net_profit AS decimal(12, 2))) agg5,
       avg(cast(fca.c_birth_year AS decimal(12, 2))) agg6
FROM filtered_sales fs
JOIN filtered_item i ON fs.cs_item_sk = i.i_item_sk
JOIN filtered_cdemo cd ON fs.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN filtered_cust_addr fca ON fs.cs_bill_customer_sk = fca.c_customer_sk
GROUP BY ROLLUP (i.i_item_id,
                 fca.ca_country,
                 fca.ca_state,
                 fca.ca_county)
ORDER BY fca.ca_country,
         fca.ca_state,
         fca.ca_county,
         i.i_item_id
LIMIT 100;