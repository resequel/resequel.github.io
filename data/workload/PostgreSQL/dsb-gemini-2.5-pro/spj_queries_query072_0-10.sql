WITH relevant_dates AS
  (SELECT d1.d_date_sk AS d1_sk,
          d1.d_week_seq,
          d1.d_date AS d1_date,
          d3.d_date_sk AS d3_sk
   FROM date_dim d1,
        date_dim d3
   WHERE d1.d_year = 2001
     AND d3.d_date > d1.d_date + interval '3 day'),
     relevant_inv AS
  (SELECT inv.inv_item_sk,
          inv.inv_warehouse_sk,
          inv.inv_quantity_on_hand
   FROM inventory inv
   JOIN date_dim d2 ON inv.inv_date_sk = d2.d_date_sk
   WHERE d2.d_week_seq IN
       (SELECT d_week_seq
        FROM relevant_dates))
SELECT min(cs.cs_item_sk),
       min(w.w_warehouse_name),
       min(rd.d_week_seq),
       min(cs.cs_order_number)
FROM catalog_sales cs
JOIN relevant_dates rd ON cs.cs_sold_date_sk = rd.d1_sk
AND cs.cs_ship_date_sk = rd.d3_sk
JOIN relevant_inv ri ON cs.cs_item_sk = ri.inv_item_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN customer_demographics cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON cs.cs_bill_hdemo_sk = hd.hd_demo_sk
JOIN warehouse w ON ri.inv_warehouse_sk = w.w_warehouse_sk
WHERE ri.inv_quantity_on_hand < cs.cs_quantity
  AND cs.cs_wholesale_cost BETWEEN 80 AND 100
  AND i.i_category IN ('Books',
                     'Home',
                     'Sports')
  AND cd.cd_marital_status = 'U'
  AND cd.cd_dep_count BETWEEN 5 AND 7
  AND hd.hd_buy_potential = '1001-5000';