WITH filtered_sales AS
  (SELECT i.i_item_id,
          s.s_state,
          ss.ss_quantity,
          ss.ss_list_price,
          ss.ss_coupon_amt,
          ss.ss_sales_price
   FROM store_sales ss
   JOIN item i ON ss.ss_item_sk = i.i_item_sk
   AND i.i_category = 'Jewelry'
   JOIN store s ON ss.ss_store_sk = s.s_store_sk
   AND s.s_state = 'IL'
   WHERE ss.ss_sold_date_sk IN
       (SELECT d_date_sk
        FROM date_dim
        WHERE d_year = 2002)
     AND ss.ss_cdemo_sk IN
       (SELECT cd_demo_sk
        FROM customer_demographics
        WHERE cd_gender = 'M'
          AND cd_marital_status = 'S'
          AND cd_education_status = 'College'))
  (SELECT i_item_id,
          s_state,
          0 AS g_state,
          avg(ss_quantity) AS agg1,
          avg(ss_list_price) AS agg2,
          avg(ss_coupon_amt) AS agg3,
          avg(ss_sales_price) AS agg4
   FROM filtered_sales
   GROUP BY i_item_id,
            s_state)
UNION ALL
  (SELECT i_item_id,
          NULL AS s_state,
          1 AS g_state,
          avg(ss_quantity),
          avg(ss_list_price),
          avg(ss_coupon_amt),
          avg(ss_sales_price)
   FROM filtered_sales
   GROUP BY i_item_id)
ORDER BY i_item_id,
         s_state
LIMIT 100;