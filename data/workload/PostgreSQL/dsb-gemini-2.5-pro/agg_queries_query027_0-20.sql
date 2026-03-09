WITH date_dim_filtered AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 2002),
     item_filtered AS
  (SELECT i_item_sk,
          i_item_id
   FROM item
   WHERE i_category = 'Jewelry'),
     store_filtered AS
  (SELECT s_store_sk,
          s_state
   FROM store
   WHERE s_state = 'IL'),
     customer_demographics_filtered AS
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
JOIN date_dim_filtered d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN item_filtered i ON ss.ss_item_sk = i.i_item_sk
JOIN store_filtered s ON ss.ss_store_sk = s.s_store_sk
JOIN customer_demographics_filtered c ON ss.ss_cdemo_sk = c.cd_demo_sk
GROUP BY ROLLUP (i.i_item_id,
                 s.s_state)
ORDER BY i.i_item_id,
         s.s_state
LIMIT 100;