WITH filtered_date AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 2001),
     filtered_item AS
  (SELECT i_item_sk,
          i_item_id
   FROM item
   WHERE i_category = 'Jewelry'),
     filtered_cd AS
  (SELECT cd_demo_sk,
          cd_dep_count
   FROM customer_demographics
   WHERE cd_gender = 'F'
     AND cd_education_status = 'College'),
     filtered_c AS
  (SELECT c_customer_sk,
          c_current_addr_sk,
          c_birth_year
   FROM customer
   WHERE c_birth_month = 5),
     filtered_ca AS
  (SELECT ca_address_sk,
          ca_country,
          ca_state,
          ca_county
   FROM customer_address
   WHERE ca_state IN ('MT',
                   'OH',
                   'OR'))
SELECT min(fi.i_item_id),
       min(fca.ca_country),
       min(fca.ca_state),
       min(fca.ca_county),
       min(cs.cs_quantity),
       min(cs.cs_list_price),
       min(cs.cs_coupon_amt),
       min(cs.cs_sales_price),
       min(cs.cs_net_profit),
       min(fc.c_birth_year),
       min(fcd.cd_dep_count)
FROM catalog_sales cs
JOIN filtered_date fd ON cs.cs_sold_date_sk = fd.d_date_sk
JOIN filtered_item fi ON cs.cs_item_sk = fi.i_item_sk
JOIN filtered_cd fcd ON cs.cs_bill_cdemo_sk = fcd.cd_demo_sk
JOIN filtered_c fc ON cs.cs_bill_customer_sk = fc.c_customer_sk
JOIN filtered_ca fca ON fc.c_current_addr_sk = fca.ca_address_sk
WHERE cs.cs_wholesale_cost BETWEEN 84 AND 89;