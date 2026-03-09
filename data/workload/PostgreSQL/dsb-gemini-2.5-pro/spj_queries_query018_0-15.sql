
SELECT min(i.i_item_id),
       min(ca.ca_country),
       min(ca.ca_state),
       min(ca.ca_county),
       min(cs.cs_quantity),
       min(cs.cs_list_price),
       min(cs.cs_coupon_amt),
       min(cs.cs_sales_price),
       min(cs.cs_net_profit),
       min(c.c_birth_year),
       min(cd.cd_dep_count)
FROM catalog_sales cs
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN customer_demographics cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
WHERE cs.cs_wholesale_cost BETWEEN 84 AND 89
  AND i.i_category = 'Jewelry'
  AND d.d_year = 2001
  AND cd.cd_gender = 'F'
  AND cd.cd_education_status = 'College'
  AND c.c_birth_month = 5
  AND ca.ca_state IN ('MT',
                   'OH',
                   'OR')
  AND EXISTS
    (SELECT 1
     FROM date_dim d2
     WHERE d2.d_date_sk = cs.cs_sold_date_sk
       AND d2.d_year = 2001)
  AND EXISTS
    (SELECT 1
     FROM customer c2
     JOIN customer_address ca2 ON c2.c_current_addr_sk = ca2.ca_address_sk
     WHERE c2.c_customer_sk = cs.cs_bill_customer_sk
       AND c2.c_birth_month = 5
       AND ca2.ca_state IN ('MT',
                   'OH',
                   'OR'));