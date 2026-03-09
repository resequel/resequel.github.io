
SELECT i.i_item_desc,
       w.w_warehouse_name,
       d1.d_week_seq,
       sum(CASE
               WHEN p.p_promo_sk IS NULL THEN 1
               ELSE 0
           END) AS no_promo,
       sum(CASE
               WHEN p.p_promo_sk IS NOT NULL THEN 1
               ELSE 0
           END) AS promo,
       count(*) AS total_cnt
FROM inventory inv
JOIN warehouse w ON inv.inv_warehouse_sk = w.w_warehouse_sk
JOIN date_dim d2 ON inv.inv_date_sk = d2.d_date_sk
JOIN catalog_sales cs ON inv.inv_item_sk = cs.cs_item_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN date_dim d1 ON cs.cs_sold_date_sk = d1.d_date_sk
AND d1.d_week_seq = d2.d_week_seq
JOIN date_dim d3 ON cs.cs_ship_date_sk = d3.d_date_sk
JOIN customer_demographics cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON cs.cs_bill_hdemo_sk = hd.hd_demo_sk
LEFT OUTER JOIN promotion p ON cs.cs_promo_sk = p.p_promo_sk
WHERE inv.inv_quantity_on_hand < cs.cs_quantity
  AND d1.d_year = 2001
  AND d3.d_date > d1.d_date + interval '3 day'
  AND i.i_category IN ('Books',
                     'Home',
                     'Sports')
  AND cd.cd_marital_status = 'U'
  AND cd.cd_dep_count BETWEEN 5 AND 7
  AND hd.hd_buy_potential = '1001-5000'
  AND cs.cs_wholesale_cost BETWEEN 80 AND 100
GROUP BY i.i_item_desc,
         w.w_warehouse_name,
         d1.d_week_seq
ORDER BY total_cnt DESC,
         i.i_item_desc,
         w.w_warehouse_name,
         d1.d_week_seq
LIMIT 100;