WITH filtered_ss AS
  (SELECT ss_item_sk,
          ss_store_sk,
          ss_cdemo_sk,
          ss_quantity,
          ss_list_price,
          ss_coupon_amt,
          ss_sales_price
   FROM store_sales
   WHERE ss_sold_date_sk IN
       (SELECT d_date_sk
        FROM date_dim
        WHERE d_year = 2002))
SELECT i.i_item_id,
       s.s_state,
       grouping(s.s_state) AS g_state,
       avg(ss.ss_quantity) AS agg1,
       avg(ss.ss_list_price) AS agg2,
       avg(ss.ss_coupon_amt) AS agg3,
       avg(ss.ss_sales_price) AS agg4
FROM filtered_ss ss
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
WHERE i.i_category = 'Jewelry'
  AND s.s_state = 'IL'
  AND cd.cd_gender = 'M'
  AND cd.cd_marital_status = 'S'
  AND cd.cd_education_status = 'College'
GROUP BY ROLLUP (i.i_item_id,
                 s.s_state)
ORDER BY i.i_item_id,
         s.s_state
LIMIT 100;