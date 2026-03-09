WITH filtered_dates AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 2001),
     filtered_items AS
  (SELECT i_item_sk,
          i_item_id
   FROM item
   WHERE i_category = 'Jewelry'),
     filtered_demos AS
  (SELECT cd_demo_sk,
          cd_dep_count
   FROM customer_demographics
   WHERE cd_gender = 'F'
     AND cd_education_status = 'College'),
     filtered_customers AS
  (SELECT c_customer_sk,
          c_current_addr_sk,
          c_birth_year
   FROM customer
   WHERE c_birth_month = 5),
     filtered_addresses AS
  (SELECT ca_address_sk,
          ca_country,
          ca_state,
          ca_county
   FROM customer_address
   WHERE ca_state IN ('MT',
                   'OH',
                   'OR'))
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
JOIN filtered_dates d ON cs.cs_sold_date_sk = d.d_date_sk
JOIN filtered_items i ON cs.cs_item_sk = i.i_item_sk
JOIN filtered_demos cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN filtered_customers c ON cs.cs_bill_customer_sk = c.c_customer_sk
JOIN filtered_addresses ca ON c.c_current_addr_sk = ca.ca_address_sk
WHERE cs.cs_wholesale_cost BETWEEN 84 AND 89;