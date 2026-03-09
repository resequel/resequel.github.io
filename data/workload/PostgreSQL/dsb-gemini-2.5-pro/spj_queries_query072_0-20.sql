WITH filtered_d1 AS
  (SELECT d_date_sk,
          d_week_seq,
          d_date
   FROM date_dim
   WHERE d_year = 2001)
SELECT min(cs.cs_item_sk),
       min(w.w_warehouse_name),
       min(d1.d_week_seq),
       min(cs.cs_order_number)
FROM catalog_sales cs
JOIN filtered_d1 d1 ON cs.cs_sold_date_sk = d1.d_date_sk
JOIN inventory inv ON cs.cs_item_sk = inv.inv_item_sk
JOIN date_dim d2 ON inv.inv_date_sk = d2.d_date_sk
JOIN warehouse w ON inv.inv_warehouse_sk = w.w_warehouse_sk
JOIN date_dim d3 ON cs.cs_ship_date_sk = d3.d_date_sk
WHERE cs.cs_wholesale_cost BETWEEN 80 AND 100
  AND d1.d_week_seq = d2.d_week_seq
  AND inv.inv_quantity_on_hand < cs.cs_quantity
  AND d3.d_date > d1.d_date + interval '3 day'
  AND EXISTS
    (SELECT 1
     FROM item i
     WHERE i.i_item_sk = cs.cs_item_sk
       AND i.i_category IN ('Books',
                     'Home',
                     'Sports'))
  AND EXISTS
    (SELECT 1
     FROM customer_demographics cd
     WHERE cd.cd_demo_sk = cs.cs_bill_cdemo_sk
       AND cd.cd_marital_status = 'U'
       AND cd.cd_dep_count BETWEEN 5 AND 7)
  AND EXISTS
    (SELECT 1
     FROM household_demographics hd
     WHERE hd.hd_demo_sk = cs.cs_bill_hdemo_sk
       AND hd.hd_buy_potential = '1001-5000');