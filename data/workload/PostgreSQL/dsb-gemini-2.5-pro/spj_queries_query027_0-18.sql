WITH filtered_dims AS
  (SELECT cd_demo_sk
   FROM customer_demographics
   WHERE cd_gender = 'M'
     AND cd_marital_status = 'S'
     AND cd_education_status = 'College'),
     filtered_sales AS
  (SELECT ss.ss_item_sk,
          ss.ss_store_sk,
          ss.ss_quantity,
          ss.ss_list_price,
          ss.ss_coupon_amt,
          ss.ss_sales_price,
          ss.ss_ticket_number
   FROM store_sales ss
   JOIN filtered_dims fd ON ss.ss_cdemo_sk = fd.cd_demo_sk
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   AND d.d_year = 2002)
SELECT min(i.i_item_id),
       min(s.s_state),
       min(fs.ss_quantity),
       min(fs.ss_list_price),
       min(fs.ss_coupon_amt),
       min(fs.ss_sales_price),
       min(fs.ss_item_sk),
       min(fs.ss_ticket_number)
FROM filtered_sales fs
JOIN item i ON fs.ss_item_sk = i.i_item_sk
AND i.i_category = 'Jewelry'
JOIN store s ON fs.ss_store_sk = s.s_store_sk
AND s.s_state = 'IL';