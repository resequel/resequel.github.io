WITH sales_filtered AS
  (SELECT cs.cs_item_sk,
          cs.cs_bill_cdemo_sk,
          cs.cs_bill_customer_sk,
          cs.cs_quantity,
          cs.cs_list_price,
          cs.cs_coupon_amt,
          cs.cs_sales_price,
          cs.cs_net_profit
   FROM catalog_sales cs
   JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
   WHERE d.d_year = 2001
     AND cs.cs_wholesale_cost BETWEEN 84 AND 89),
     sales_agg AS
  (SELECT cs_item_sk,
          cs_bill_cdemo_sk,
          cs_bill_customer_sk,
          sum(cs_quantity) s_q,
          count(cs_quantity) c_q,
          sum(cs_list_price) s_lp,
          count(cs_list_price) c_lp,
          sum(cs_coupon_amt) s_ca,
          count(cs_coupon_amt) c_ca,
          sum(cs_sales_price) s_sp,
          count(cs_sales_price) c_sp,
          sum(cs_net_profit) s_np,
          count(cs_net_profit) c_np
   FROM sales_filtered
   GROUP BY cs_item_sk,
            cs_bill_cdemo_sk,
            cs_bill_customer_sk)
SELECT i.i_item_id,
       ca.ca_country,
       ca.ca_state,
       ca.ca_county,
       sum(s_q)/sum(c_q),
       sum(s_lp)/sum(c_lp),
       sum(s_ca)/sum(c_ca),
       sum(s_sp)/sum(c_sp),
       sum(s_np)/sum(c_np),
       avg(cast(c.c_birth_year AS decimal(12, 2)))
FROM sales_agg sa
JOIN item i ON sa.cs_item_sk=i.i_item_sk
JOIN customer_demographics cd ON sa.cs_bill_cdemo_sk=cd.cd_demo_sk
JOIN customer c ON sa.cs_bill_customer_sk=c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk=ca.ca_address_sk
WHERE i.i_category = 'Jewelry'
  AND cd.cd_gender = 'F'
  AND cd.cd_education_status = 'College'
  AND c.c_birth_month = 5
  AND ca.ca_state IN ('MT',
                   'OH',
                   'OR')
GROUP BY ROLLUP(i.i_item_id, ca.ca_country, ca.ca_state, ca.ca_county)
ORDER BY ca.ca_country,
         ca.ca_state,
         ca.ca_county,
         i.i_item_id
LIMIT 100;