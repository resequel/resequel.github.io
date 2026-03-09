WITH sales_in_year AS
  (SELECT ss.ss_item_sk,
          ss.ss_store_sk,
          ss.ss_cdemo_sk,
          ss.ss_quantity,
          ss.ss_list_price,
          ss.ss_coupon_amt,
          ss.ss_sales_price,
          ss.ss_ticket_number
   FROM store_sales ss
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   WHERE d.d_year = 2002)
SELECT min(i.i_item_id),
       min(s.s_state),
       min(siy.ss_quantity),
       min(siy.ss_list_price),
       min(siy.ss_coupon_amt),
       min(siy.ss_sales_price),
       min(siy.ss_item_sk),
       min(siy.ss_ticket_number)
FROM sales_in_year siy
JOIN item i ON siy.ss_item_sk = i.i_item_sk
JOIN store s ON siy.ss_store_sk = s.s_store_sk
JOIN customer_demographics cd ON siy.ss_cdemo_sk = cd.cd_demo_sk
WHERE i.i_category = 'Jewelry'
  AND s.s_state = 'IL'
  AND cd.cd_gender = 'M'
  AND cd.cd_marital_status = 'S'
  AND cd.cd_education_status = 'College';