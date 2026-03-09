
SELECT i.i_item_id,
       s.s_state,
       grouping(s.s_state) AS g_state,
       avg(ss.ss_quantity) AS agg1,
       avg(ss.ss_list_price) AS agg2,
       avg(ss.ss_coupon_amt) AS agg3,
       avg(ss.ss_sales_price) AS agg4
FROM store_sales ss
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
AND d.d_year = 2002
JOIN item i ON ss.ss_item_sk = i.i_item_sk
AND i.i_category = 'Jewelry'
JOIN store s ON ss.ss_store_sk = s.s_store_sk
AND s.s_state = 'IL'
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
AND cd.cd_gender = 'M'
AND cd.cd_marital_status = 'S'
AND cd.cd_education_status = 'College'
GROUP BY GROUPING
SETS ((i.i_item_id,
       s.s_state), (i.i_item_id), ())
ORDER BY i.i_item_id,
         s.s_state
LIMIT 100;