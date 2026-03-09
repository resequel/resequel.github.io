
SELECT i.i_item_id,
       s.s_state,
       grouping(s.s_state) g_state,
       avg(ss_quantity) agg1,
       avg(ss_list_price) agg2,
       avg(ss_coupon_amt) agg3,
       avg(ss_sales_price) agg4
FROM store_sales
JOIN customer_demographics ON ss_cdemo_sk = cd_demo_sk
JOIN date_dim ON ss_sold_date_sk = d_date_sk
JOIN store ON ss_store_sk = s_store_sk
JOIN item ON ss_item_sk = i_item_sk
WHERE cd_gender = 'M'
  AND cd_marital_status = 'S'
  AND cd_education_status = 'College'
  AND d_year = 2002
  AND s_state = 'IL'
  AND i_category = 'Jewelry'
GROUP BY ROLLUP (i_item_id,
                 s_state)
ORDER BY i_item_id,
         s_state
LIMIT 100;