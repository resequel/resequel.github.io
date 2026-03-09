WITH filtered_cust AS
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
SELECT min(i.i_item_id),
       min(fc.ca_country),
       min(fc.ca_state),
       min(fc.ca_county),
       min(cs.cs_quantity),
       min(cs.cs_list_price),
       min(cs.cs_coupon_amt),
       min(cs.cs_sales_price),
       min(cs.cs_net_profit),
       min(fc.c_birth_year),
       min(cd.cd_dep_count)
FROM catalog_sales cs
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN customer_demographics cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN filtered_cust fc ON cs.cs_bill_customer_sk = fc.c_customer_sk
WHERE d.d_year = 2001
  AND i.i_category = 'Jewelry'
  AND cd.cd_gender = 'F'
  AND cd.cd_education_status = 'College'
  AND cs.cs_wholesale_cost BETWEEN 84 AND 89;