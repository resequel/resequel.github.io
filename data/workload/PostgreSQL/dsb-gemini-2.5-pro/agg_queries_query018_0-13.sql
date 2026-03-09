WITH base_data AS
  (SELECT i.i_item_id,
          ca.ca_country,
          ca.ca_state,
          ca.ca_county,
          cs.cs_quantity,
          cs.cs_list_price,
          cs.cs_coupon_amt,
          cs.cs_sales_price,
          cs.cs_net_profit,
          c.c_birth_year
   FROM catalog_sales cs
   JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
   JOIN item i ON cs.cs_item_sk = i.i_item_sk
   JOIN customer_demographics cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk
   JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   WHERE d.d_year = 2001
     AND cs.cs_wholesale_cost BETWEEN 84 AND 89
     AND i.i_category = 'Jewelry'
     AND cd.cd_gender = 'F'
     AND cd.cd_education_status = 'College'
     AND c.c_birth_month = 5
     AND ca.ca_state IN ('MT',
                   'OH',
                   'OR'))
SELECT i_item_id,
       ca_country,
       ca_state,
       ca_county,
       avg(cast(cs_quantity AS decimal(12, 2))),
       avg(cast(cs_list_price AS decimal(12, 2))),
       avg(cast(cs_coupon_amt AS decimal(12, 2))),
       avg(cast(cs_sales_price AS decimal(12, 2))),
       avg(cast(cs_net_profit AS decimal(12, 2))),
       avg(cast(c_birth_year AS decimal(12, 2)))
FROM base_data
GROUP BY i_item_id,
         ca_country,
         ca_state,
         ca_county
UNION ALL
SELECT i_item_id,
       ca_country,
       ca_state,
       NULL,
       avg(cast(cs_quantity AS decimal(12, 2))),
       avg(cast(cs_list_price AS decimal(12, 2))),
       avg(cast(cs_coupon_amt AS decimal(12, 2))),
       avg(cast(cs_sales_price AS decimal(12, 2))),
       avg(cast(cs_net_profit AS decimal(12, 2))),
       avg(cast(c_birth_year AS decimal(12, 2)))
FROM base_data
GROUP BY i_item_id,
         ca_country,
         ca_state
UNION ALL
SELECT i_item_id,
       ca_country,
       NULL,
       NULL,
       avg(cast(cs_quantity AS decimal(12, 2))),
       avg(cast(cs_list_price AS decimal(12, 2))),
       avg(cast(cs_coupon_amt AS decimal(12, 2))),
       avg(cast(cs_sales_price AS decimal(12, 2))),
       avg(cast(cs_net_profit AS decimal(12, 2))),
       avg(cast(c_birth_year AS decimal(12, 2)))
FROM base_data
GROUP BY i_item_id,
         ca_country
UNION ALL
SELECT i_item_id,
       NULL,
       NULL,
       NULL,
       avg(cast(cs_quantity AS decimal(12, 2))),
       avg(cast(cs_list_price AS decimal(12, 2))),
       avg(cast(cs_coupon_amt AS decimal(12, 2))),
       avg(cast(cs_sales_price AS decimal(12, 2))),
       avg(cast(cs_net_profit AS decimal(12, 2))),
       avg(cast(c_birth_year AS decimal(12, 2)))
FROM base_data
GROUP BY i_item_id
UNION ALL
SELECT NULL,
       NULL,
       NULL,
       NULL,
       avg(cast(cs_quantity AS decimal(12, 2))),
       avg(cast(cs_list_price AS decimal(12, 2))),
       avg(cast(cs_coupon_amt AS decimal(12, 2))),
       avg(cast(cs_sales_price AS decimal(12, 2))),
       avg(cast(cs_net_profit AS decimal(12, 2))),
       avg(cast(c_birth_year AS decimal(12, 2)))
FROM base_data
ORDER BY ca_country,
         ca_state,
         ca_county,
         i_item_id
LIMIT 100;