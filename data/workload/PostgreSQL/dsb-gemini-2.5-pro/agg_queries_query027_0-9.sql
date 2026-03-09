WITH prejoined_sales AS
  (SELECT i.i_item_id,
          s.s_state,
          ss.ss_quantity,
          ss.ss_list_price,
          ss.ss_coupon_amt,
          ss.ss_sales_price
   FROM store_sales ss
   JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN store s ON ss.ss_store_sk = s.s_store_sk
   JOIN item i ON ss.ss_item_sk = i.i_item_sk
   WHERE cd.cd_gender = 'M'
     AND cd.cd_marital_status = 'S'
     AND cd.cd_education_status = 'College'
     AND d.d_year = 2002
     AND s.s_state = 'IL'
     AND i.i_category = 'Jewelry')
SELECT i_item_id,
       s_state,
       grouping(s_state) g_state,
       avg(ss_quantity) agg1,
       avg(ss_list_price) agg2,
       avg(ss_coupon_amt) agg3,
       avg(ss_sales_price) agg4
FROM prejoined_sales
GROUP BY ROLLUP (i_item_id,
                 s_state)
ORDER BY i_item_id,
         s_state
LIMIT 100;