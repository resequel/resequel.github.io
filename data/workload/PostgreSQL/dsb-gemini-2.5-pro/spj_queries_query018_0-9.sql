
SELECT min(q.i_item_id),
       min(q.ca_country),
       min(q.ca_state),
       min(q.ca_county),
       min(cs.cs_quantity),
       min(cs.cs_list_price),
       min(cs.cs_coupon_amt),
       min(cs.cs_sales_price),
       min(cs.cs_net_profit),
       min(q.c_birth_year),
       min(q.cd_dep_count)
FROM catalog_sales cs,
     LATERAL
  (SELECT i.i_item_id,
          ca.ca_country,
          ca.ca_state,
          ca.ca_county,
          c.c_birth_year,
          cd.cd_dep_count
   FROM item i
   JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
   JOIN customer_demographics cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk
   JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   WHERE cs.cs_item_sk = i.i_item_sk
     AND d.d_year = 2001
     AND i.i_category = 'Jewelry'
     AND cd.cd_gender = 'F'
     AND cd.cd_education_status = 'College'
     AND c.c_birth_month = 5
     AND ca.ca_state IN ('MT',
                   'OH',
                   'OR')
   LIMIT 1) AS q
WHERE cs.cs_wholesale_cost BETWEEN 84 AND 89
  AND q.i_item_id IS NOT NULL;