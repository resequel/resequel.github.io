WITH filtered_cd AS
  (SELECT cd_demo_sk
   FROM customer_demographics
   WHERE cd_gender = 'M'
     AND cd_marital_status = 'S'
     AND cd_education_status = 'College'),
     filtered_dd AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 2002),
     filtered_s AS
  (SELECT s_store_sk,
          s_state
   FROM store
   WHERE s_state = 'IL'),
     filtered_i AS
  (SELECT i_item_sk,
          i_item_id
   FROM item
   WHERE i_category = 'Jewelry')
SELECT i.i_item_id,
       s.s_state,
       grouping(s.s_state) AS g_state,
       avg(ss.ss_quantity) AS agg1,
       avg(ss.ss_list_price) AS agg2,
       avg(ss.ss_coupon_amt) AS agg3,
       avg(ss.ss_sales_price) AS agg4
FROM store_sales ss
JOIN filtered_dd dd ON ss.ss_sold_date_sk = dd.d_date_sk
JOIN filtered_cd cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
JOIN filtered_s s ON ss.ss_store_sk = s.s_store_sk
JOIN filtered_i i ON ss.ss_item_sk = i.i_item_sk
GROUP BY ROLLUP (i.i_item_id,
                 s.s_state)
ORDER BY i.i_item_id,
         s.s_state
LIMIT 100;