
SELECT *
FROM
  (SELECT i.i_item_id,
          s.s_state,
          grouping(s.s_state) AS g_state,
          avg(ss.ss_quantity) AS agg1,
          avg(ss.ss_list_price) AS agg2,
          avg(ss.ss_coupon_amt) AS agg3,
          avg(ss.ss_sales_price) AS agg4
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
          AND cd_education_status = 'College')
   GROUP BY ROLLUP (i.i_item_id,
                    s.s_state)) AS results
ORDER BY i_item_id,
         s_state
LIMIT 100;