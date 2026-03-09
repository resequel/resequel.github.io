
SELECT i.i_item_id,
       ca.ca_country,
       ca.ca_state,
       ca.ca_county,
       avg(CAST(cs.cs_quantity AS decimal(12, 2))),
       avg(CAST(cs.cs_list_price AS decimal(12, 2))),
       avg(CAST(cs.cs_coupon_amt AS decimal(12, 2))),
       avg(CAST(cs.cs_sales_price AS decimal(12, 2))),
       avg(CAST(cs.cs_net_profit AS decimal(12, 2))),
       avg(CAST(c.c_birth_year AS decimal(12, 2)))
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
  (SELECT cd_demo_sk
   FROM customer_demographics
   WHERE cd_gender = 'F'
     AND cd_education_status = 'College') cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN
  (SELECT c_customer_sk,
          c_birth_year,
          c_current_addr_sk
   FROM customer
   WHERE c_birth_month = 5) c ON cs.cs_bill_customer_sk = c.c_customer_sk
JOIN
  (SELECT ca_address_sk,
          ca_country,
          ca_state,
          ca_county
   FROM customer_address
   WHERE ca_state IN ('MT',
                   'OH',
                   'OR')) ca ON c.c_current_addr_sk = ca.ca_address_sk
WHERE cs.cs_wholesale_cost BETWEEN 84 AND 89
GROUP BY ROLLUP (i.i_item_id,
                 ca.ca_country,
                 ca.ca_state,
                 ca.ca_county)
ORDER BY ca.ca_country,
         ca.ca_state,
         ca.ca_county,
         i.i_item_id
LIMIT 100;