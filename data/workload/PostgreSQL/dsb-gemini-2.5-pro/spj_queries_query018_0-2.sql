
SELECT min(i.i_item_id),
       min(c_ca.ca_country),
       min(c_ca.ca_state),
       min(c_ca.ca_county),
       min(cs.cs_quantity),
       min(cs.cs_list_price),
       min(cs.cs_coupon_amt),
       min(cs.cs_sales_price),
       min(cs.cs_net_profit),
       min(c_ca.c_birth_year),
       min(cd.cd_dep_count)
FROM catalog_sales cs
JOIN
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 2001) d ON cs.cs_sold_date_sk = d.d_date_sk
JOIN
  (SELECT i_item_sk,
          i_item_id
   FROM item
   WHERE i_category = 'Jewelry') i ON cs.cs_item_sk = i.i_item_sk
JOIN
  (SELECT cd_demo_sk,
          cd_dep_count
   FROM customer_demographics
   WHERE cd_gender = 'F'
     AND cd_education_status = 'College') cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN
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
                   'OR')) c_ca ON cs.cs_bill_customer_sk = c_ca.c_customer_sk
WHERE cs.cs_wholesale_cost BETWEEN 84 AND 89;