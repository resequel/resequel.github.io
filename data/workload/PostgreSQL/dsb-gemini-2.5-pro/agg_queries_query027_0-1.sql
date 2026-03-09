WITH base_data AS
  (SELECT i.i_item_id,
          s.s_state,
          ss.ss_quantity,
          ss.ss_list_price,
          ss.ss_coupon_amt,
          ss.ss_sales_price
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
   AND cd.cd_education_status = 'College')
SELECT i_item_id,
       s_state,
       0 AS g_state,
       avg(ss_quantity),
       avg(ss_list_price),
       avg(ss_coupon_amt),
       avg(ss_sales_price)
FROM base_data
GROUP BY i_item_id,
         s_state
UNION ALL
SELECT i_item_id,
       NULL AS s_state,
       1 AS g_state,
       avg(ss_quantity),
       avg(ss_list_price),
       avg(ss_coupon_amt),
       avg(ss_sales_price)
FROM base_data
GROUP BY i_item_id
ORDER BY i_item_id,
         s_state
LIMIT 100;