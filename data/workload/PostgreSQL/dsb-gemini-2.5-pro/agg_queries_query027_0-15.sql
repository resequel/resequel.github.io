WITH date_keys AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 2002),
     demo_keys AS
  (SELECT cd_demo_sk
   FROM customer_demographics
   WHERE cd_gender = 'M'
     AND cd_marital_status = 'S'
     AND cd_education_status = 'College')
SELECT i.i_item_id,
       s.s_state,
       grouping(s.s_state) AS g_state,
       avg(ss.ss_quantity) AS agg1,
       avg(ss.ss_list_price) AS agg2,
       avg(ss.ss_coupon_amt) AS agg3,
       avg(ss.ss_sales_price) AS agg4
FROM store_sales ss
JOIN date_keys ON ss.ss_sold_date_sk = date_keys.d_date_sk
JOIN demo_keys ON ss.ss_cdemo_sk = demo_keys.cd_demo_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
AND s.s_state = 'IL'
JOIN item i ON ss.ss_item_sk = i.i_item_sk
AND i.i_category = 'Jewelry'
GROUP BY ROLLUP (i.i_item_id,
                 s.s_state)
ORDER BY i.i_item_id,
         s.s_state
LIMIT 100;