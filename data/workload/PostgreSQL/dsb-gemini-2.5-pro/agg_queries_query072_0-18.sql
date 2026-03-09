WITH filtered_d1 AS
  (SELECT d_date_sk,
          d_week_seq,
          d_date
   FROM date_dim
   WHERE d_year = 2001),
     filtered_cd AS
  (SELECT cd_demo_sk
   FROM customer_demographics
   WHERE cd_marital_status = 'U'
     AND cd_dep_count BETWEEN 5 AND 7),
     filtered_hd AS
  (SELECT hd_demo_sk
   FROM household_demographics
   WHERE hd_buy_potential = '1001-5000'),
     filtered_item AS
  (SELECT i_item_sk,
          i_item_desc
   FROM item
   WHERE i_category IN ('Books',
                     'Home',
                     'Sports'))
SELECT fi.i_item_desc,
       w.w_warehouse_name,
       fd1.d_week_seq,
       sum(CASE
               WHEN p.p_promo_sk IS NULL THEN 1
               ELSE 0
           END) AS no_promo,
       sum(CASE
               WHEN p.p_promo_sk IS NOT NULL THEN 1
               ELSE 0
           END) AS promo,
       count(*) AS total_cnt
FROM catalog_sales cs
JOIN filtered_d1 fd1 ON cs.cs_sold_date_sk = fd1.d_date_sk
JOIN date_dim d3 ON cs.cs_ship_date_sk = d3.d_date_sk
JOIN filtered_cd fcd ON cs.cs_bill_cdemo_sk = fcd.cd_demo_sk
JOIN filtered_hd fhd ON cs.cs_bill_hdemo_sk = fhd.hd_demo_sk
JOIN filtered_item fi ON cs.cs_item_sk = fi.i_item_sk
JOIN inventory inv ON cs.cs_item_sk = inv.inv_item_sk
JOIN date_dim d2 ON inv.inv_date_sk = d2.d_date_sk
JOIN warehouse w ON inv.inv_warehouse_sk = w.w_warehouse_sk
LEFT OUTER JOIN promotion p ON cs.cs_promo_sk = p.p_promo_sk
WHERE cs.cs_wholesale_cost BETWEEN 80 AND 100
  AND d3.d_date > fd1.d_date + interval '3 day'
  AND fd1.d_week_seq = d2.d_week_seq
  AND inv.inv_quantity_on_hand < cs.cs_quantity
GROUP BY fi.i_item_desc,
         w.w_warehouse_name,
         fd1.d_week_seq
ORDER BY total_cnt DESC,
         fi.i_item_desc,
         w.w_warehouse_name,
         fd1.d_week_seq
LIMIT 100;