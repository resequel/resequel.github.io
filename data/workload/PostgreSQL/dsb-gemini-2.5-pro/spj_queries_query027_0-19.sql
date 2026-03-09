
SELECT min(i.i_item_id),
       min(s.s_state),
       min(ss.ss_quantity),
       min(ss.ss_list_price),
       min(ss.ss_coupon_amt),
       min(ss.ss_sales_price),
       min(ss.ss_item_sk),
       min(ss.ss_ticket_number)
FROM store s
JOIN store_sales ss ON s.s_store_sk = ss.ss_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
WHERE s.s_state = 'IL'
  AND d.d_year = 2002
  AND i.i_category = 'Jewelry'
  AND cd.cd_gender = 'M'
  AND cd.cd_marital_status = 'S'
  AND cd.cd_education_status = 'College';