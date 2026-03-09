
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
WHERE i.i_category = 'Jewelry'
  AND EXISTS
    (SELECT 1
     FROM store s
     WHERE ss.ss_store_sk = s.s_store_sk
       AND s.s_state = 'IL')
  AND EXISTS
    (SELECT 1
     FROM date_dim d
     WHERE ss.ss_sold_date_sk = d.d_date_sk
       AND d.d_year = 2002)
  AND EXISTS
    (SELECT 1
     FROM customer_demographics cd
     WHERE ss.ss_cdemo_sk = cd.cd_demo_sk
       AND cd.cd_gender = 'M'
       AND cd.cd_marital_status = 'S'
       AND cd.cd_education_status = 'College');