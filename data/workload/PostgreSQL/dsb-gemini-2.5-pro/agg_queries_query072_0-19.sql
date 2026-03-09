WITH sales_filtered AS
  (SELECT cs.cs_item_sk,
          cs.cs_quantity,
          cs.cs_promo_sk,
          d1.d_week_seq
   FROM catalog_sales AS cs
   JOIN date_dim AS d1 ON cs.cs_sold_date_sk = d1.d_date_sk
   JOIN date_dim AS d3 ON cs.cs_ship_date_sk = d3.d_date_sk
   JOIN item ON cs.cs_item_sk = i_item_sk
   JOIN customer_demographics ON cs.cs_bill_cdemo_sk = cd_demo_sk
   JOIN household_demographics ON cs.cs_bill_hdemo_sk = hd_demo_sk
   WHERE d1.d_year = 2001
     AND d3.d_date > d1.d_date + interval '3 day'
     AND i_category IN ('Books',
                     'Home',
                     'Sports')
     AND cd_marital_status = 'U'
     AND cd_dep_count BETWEEN 5 AND 7
     AND hd_buy_potential = '1001-5000'
     AND cs.cs_wholesale_cost BETWEEN 80 AND 100),
     inventory_filtered AS
  (SELECT inv.inv_item_sk,
          inv.inv_warehouse_sk,
          inv.inv_quantity_on_hand,
          d2.d_week_seq
   FROM inventory AS inv
   JOIN date_dim AS d2 ON inv.inv_date_sk = d2.d_date_sk)
SELECT i.i_item_desc,
       w.w_warehouse_name,
       sf.d_week_seq,
       sum(CASE
               WHEN p.p_promo_sk IS NULL THEN 1
               ELSE 0
           END) AS no_promo,
       sum(CASE
               WHEN p.p_promo_sk IS NOT NULL THEN 1
               ELSE 0
           END) AS promo,
       count(*) AS total_cnt
FROM sales_filtered AS sf
JOIN inventory_filtered AS inf ON sf.cs_item_sk = inf.inv_item_sk
JOIN item AS i ON sf.cs_item_sk = i.i_item_sk
JOIN warehouse AS w ON inf.inv_warehouse_sk = w.w_warehouse_sk
LEFT OUTER JOIN promotion AS p ON sf.cs_promo_sk = p.p_promo_sk
WHERE inf.inv_quantity_on_hand < sf.cs_quantity
  AND sf.d_week_seq = inf.d_week_seq
GROUP BY i.i_item_desc,
         w.w_warehouse_name,
         sf.d_week_seq
ORDER BY total_cnt DESC,
         i.i_item_desc,
         w.w_warehouse_name,
         sf.d_week_seq
LIMIT 100;