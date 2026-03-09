WITH valid_keys AS
  (SELECT d.d_date_sk,
          i.i_item_sk,
          s.s_store_sk,
          cd.cd_demo_sk,
          i.i_item_id,
          s.s_state
   FROM date_dim d,
        item i,
        store s,
        customer_demographics cd
   WHERE d.d_year = 2002
     AND i.i_category = 'Jewelry'
     AND s.s_state = 'IL'
     AND cd.cd_gender = 'M'
     AND cd.cd_marital_status = 'S'
     AND cd.cd_education_status = 'College')
SELECT min(vk.i_item_id),
       min(vk.s_state),
       min(ss.ss_quantity),
       min(ss.ss_list_price),
       min(ss.ss_coupon_amt),
       min(ss.ss_sales_price),
       min(ss.ss_item_sk),
       min(ss.ss_ticket_number)
FROM store_sales ss
JOIN valid_keys vk ON ss.ss_sold_date_sk = vk.d_date_sk
AND ss.ss_item_sk = vk.i_item_sk
AND ss.ss_store_sk = vk.s_store_sk
AND ss.ss_cdemo_sk = vk.cd_demo_sk;