WITH filtered_ss AS
  (SELECT ss_item_sk,
          ss_store_sk,
          ss_quantity,
          ss_list_price,
          ss_coupon_amt,
          ss_sales_price
   FROM store_sales
   WHERE ss_sold_date_sk IN
       (SELECT d_date_sk
        FROM date_dim
        WHERE d_year = 2002)
     AND ss_cdemo_sk IN
       (SELECT cd_demo_sk
        FROM customer_demographics
        WHERE cd_gender = 'M'
          AND cd_marital_status = 'S'
          AND cd_education_status = 'College')),
     agg_ss AS
  (SELECT ss_item_sk,
          ss_store_sk,
          SUM(ss_quantity) AS sum_q,
          COUNT(ss_quantity) AS count_q,
          SUM(ss_list_price) AS sum_lp,
          COUNT(ss_list_price) AS count_lp,
          SUM(ss_coupon_amt) AS sum_ca,
          COUNT(ss_coupon_amt) AS count_ca,
          SUM(ss_sales_price) AS sum_sp,
          COUNT(ss_sales_price) AS count_sp
   FROM filtered_ss
   GROUP BY ss_item_sk,
            ss_store_sk)
SELECT i.i_item_id,
       s.s_state,
       grouping(s.s_state) AS g_state,
       SUM(agg.sum_q) / SUM(agg.count_q) AS agg1,
       SUM(agg.sum_lp) / SUM(agg.count_lp) AS agg2,
       SUM(agg.sum_ca) / SUM(agg.count_ca) AS agg3,
       SUM(agg.sum_sp) / SUM(agg.count_sp) AS agg4
FROM agg_ss agg
JOIN item i ON agg.ss_item_sk = i.i_item_sk
AND i.i_category = 'Jewelry'
JOIN store s ON agg.ss_store_sk = s.s_store_sk
AND s.s_state = 'IL'
GROUP BY ROLLUP (i.i_item_id,
                 s.s_state)
ORDER BY i.i_item_id,
         s.s_state
LIMIT 100;