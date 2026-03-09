
SELECT min(i.i_item_id),
       ''IL'' AS min_s_state,
       min(ss.ss_quantity),
       min(ss.ss_list_price),
       min(ss.ss_coupon_amt),
       min(ss.ss_sales_price),
       min(ss.ss_item_sk),
       min(ss.ss_ticket_number)
FROM store_sales ss
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN
  (SELECT s_store_sk
   FROM store
   WHERE s_state = 'IL') s ON ss.ss_store_sk = s.s_store_sk
JOIN
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 2002) d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN
  (SELECT cd_demo_sk
   FROM customer_demographics
   WHERE cd_gender = 'M'
     AND cd_marital_status = 'S'
     AND cd_education_status = 'College') cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
WHERE i.i_category = 'Jewelry';