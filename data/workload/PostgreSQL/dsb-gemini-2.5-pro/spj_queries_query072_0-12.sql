WITH filtered_d1 AS
  (SELECT d_date_sk,
          d_week_seq,
          d_date
   FROM date_dim
   WHERE d_year = 2001),
     cs_filtered AS
  (SELECT cs_item_sk,
          cs_order_number,
          cs_quantity,
          cs_sold_date_sk,
          cs_ship_date_sk,
          cs_bill_cdemo_sk,
          cs_bill_hdemo_sk
   FROM catalog_sales
   WHERE cs_wholesale_cost BETWEEN 80 AND 100),
     inv_filtered AS
  (SELECT inv.inv_item_sk,
          inv.inv_warehouse_sk,
          inv.inv_quantity_on_hand,
          d2.d_week_seq
   FROM inventory inv
   JOIN date_dim d2 ON inv.inv_date_sk = d2.d_date_sk
   WHERE d2.d_week_seq IN
       (SELECT d_week_seq
        FROM filtered_d1))
SELECT min(cs.cs_item_sk),
       min(w.w_warehouse_name),
       min(d1.d_week_seq),
       min(cs.cs_order_number)
FROM cs_filtered cs
JOIN filtered_d1 d1 ON cs.cs_sold_date_sk = d1.d_date_sk
JOIN inv_filtered inv ON cs.cs_item_sk = inv.inv_item_sk
AND d1.d_week_seq = inv.d_week_seq
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN customer_demographics cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON cs.cs_bill_hdemo_sk = hd.hd_demo_sk
JOIN warehouse w ON inv.inv_warehouse_sk = w.w_warehouse_sk
JOIN date_dim d3 ON cs.cs_ship_date_sk = d3.d_date_sk
WHERE inv.inv_quantity_on_hand < cs.cs_quantity
  AND d3.d_date > d1.d_date + interval '3 day'
  AND i.i_category IN ('Books',
                     'Home',
                     'Sports')
  AND cd.cd_marital_status = 'U'
  AND cd.cd_dep_count BETWEEN 5 AND 7
  AND hd.hd_buy_potential = '1001-5000';