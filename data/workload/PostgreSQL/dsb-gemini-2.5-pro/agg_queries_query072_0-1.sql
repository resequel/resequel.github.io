WITH fact_join AS
  (SELECT cs.cs_item_sk,
          cs.cs_bill_cdemo_sk,
          cs.cs_bill_hdemo_sk,
          cs.cs_sold_date_sk,
          cs.cs_ship_date_sk,
          cs.cs_promo_sk,
          cs.cs_wholesale_cost,
          cs.cs_quantity,
          inv.inv_warehouse_sk,
          inv.inv_date_sk
   FROM catalog_sales cs
   JOIN inventory inv ON cs.cs_item_sk = inv.inv_item_sk
   WHERE inv.inv_quantity_on_hand < cs.cs_quantity)
SELECT i.i_item_desc,
       w.w_warehouse_name,
       d1.d_week_seq,
       sum(CASE
               WHEN p.p_promo_sk IS NULL THEN 1
               ELSE 0
           END) no_promo,
       sum(CASE
               WHEN p.p_promo_sk IS NOT NULL THEN 1
               ELSE 0
           END) promo,
       count(*) total_cnt
FROM fact_join fj
JOIN item i ON fj.cs_item_sk = i.i_item_sk
JOIN warehouse w ON fj.inv_warehouse_sk = w.w_warehouse_sk
JOIN customer_demographics cd ON fj.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON fj.cs_bill_hdemo_sk = hd.hd_demo_sk
JOIN date_dim d1 ON fj.cs_sold_date_sk = d1.d_date_sk
JOIN date_dim d2 ON fj.inv_date_sk = d2.d_date_sk
JOIN date_dim d3 ON fj.cs_ship_date_sk = d3.d_date_sk
LEFT OUTER JOIN promotion p ON fj.cs_promo_sk = p.p_promo_sk
WHERE d1.d_week_seq = d2.d_week_seq
  AND d3.d_date > d1.d_date + interval '3 day'
  AND hd.hd_buy_potential = '1001-5000'
  AND d1.d_year = 2001
  AND cd.cd_marital_status = 'U'
  AND cd.cd_dep_count BETWEEN 5 AND 7
  AND i.i_category IN ('Books',
                     'Home',
                     'Sports')
  AND fj.cs_wholesale_cost BETWEEN 80 AND 100
GROUP BY i.i_item_desc,
         w.w_warehouse_name,
         d1.d_week_seq
ORDER BY total_cnt DESC,
         i.i_item_desc,
         w.w_warehouse_name,
         d1.d_week_seq
LIMIT 100;