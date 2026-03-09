WITH filtered_cs AS
  (SELECT cs_item_sk,
          cs_bill_cdemo_sk,
          cs_bill_customer_sk,
          cs_quantity,
          cs_list_price,
          cs_coupon_amt,
          cs_sales_price,
          cs_net_profit
   FROM catalog_sales
   WHERE cs_wholesale_cost BETWEEN 84 AND 89
     AND cs_sold_date_sk IN
       (SELECT d_date_sk
        FROM date_dim
        WHERE d_year = 2001))
SELECT min(i.i_item_id),
       min(ca.ca_country),
       min(ca.ca_state),
       min(ca.ca_county),
       min(fcs.cs_quantity),
       min(fcs.cs_list_price),
       min(fcs.cs_coupon_amt),
       min(fcs.cs_sales_price),
       min(fcs.cs_net_profit),
       min(c.c_birth_year),
       min(cd.cd_dep_count)
FROM filtered_cs fcs
JOIN item i ON fcs.cs_item_sk = i.i_item_sk
JOIN customer_demographics cd ON fcs.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN customer c ON fcs.cs_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
WHERE i.i_category = 'Jewelry'
  AND cd.cd_gender = 'F'
  AND cd.cd_education_status = 'College'
  AND c.c_birth_month = 5
  AND ca.ca_state IN ('MT',
                   'OH',
                   'OR');