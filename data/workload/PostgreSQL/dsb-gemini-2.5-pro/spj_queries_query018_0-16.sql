WITH filtered_sales AS
  (SELECT *
   FROM catalog_sales
   WHERE cs_sold_date_sk IN
       (SELECT d_date_sk
        FROM date_dim
        WHERE d_year = 2001)
     AND cs_item_sk IN
       (SELECT i_item_sk
        FROM item
        WHERE i_category = 'Jewelry')
     AND cs_bill_cdemo_sk IN
       (SELECT cd_demo_sk
        FROM customer_demographics
        WHERE cd_gender = 'F'
          AND cd_education_status = 'College')
     AND cs_bill_customer_sk IN
       (SELECT c.c_customer_sk
        FROM customer c
        JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
        WHERE c.c_birth_month = 5
          AND ca.ca_state IN ('MT',
                   'OH',
                   'OR'))
     AND cs_wholesale_cost BETWEEN 84 AND 89)
SELECT min(i.i_item_id),
       min(ca.ca_country),
       min(ca.ca_state),
       min(ca.ca_county),
       min(fs.cs_quantity),
       min(fs.cs_list_price),
       min(fs.cs_coupon_amt),
       min(fs.cs_sales_price),
       min(fs.cs_net_profit),
       min(c.c_birth_year),
       min(cd.cd_dep_count)
FROM filtered_sales fs
JOIN item i ON fs.cs_item_sk = i.i_item_sk
JOIN customer_demographics cd ON fs.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN customer c ON fs.cs_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk;