WITH cs_inv AS
  (SELECT cs.cs_item_sk,
          cs.cs_order_number,
          cs.cs_sold_date_sk,
          cs.cs_ship_date_sk,
          inv.inv_warehouse_sk,
          inv.inv_date_sk,
          cs.cs_bill_cdemo_sk,
          cs.cs_bill_hdemo_sk
   FROM catalog_sales cs
   JOIN inventory inv ON cs.cs_item_sk = inv.inv_item_sk
   WHERE inv.inv_quantity_on_hand < cs.cs_quantity
     AND cs.cs_wholesale_cost BETWEEN 80 AND 100)
SELECT min(ci.cs_item_sk),
       min(w.w_warehouse_name),
       min(d1.d_week_seq),
       min(ci.cs_order_number)
FROM cs_inv ci
JOIN date_dim d1 ON ci.cs_sold_date_sk = d1.d_date_sk
JOIN date_dim d2 ON ci.inv_date_sk = d2.d_date_sk
JOIN warehouse w ON ci.inv_warehouse_sk = w.w_warehouse_sk
JOIN date_dim d3 ON ci.cs_ship_date_sk = d3.d_date_sk
JOIN item i ON ci.cs_item_sk = i.i_item_sk
JOIN customer_demographics cd ON ci.cs_bill_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON ci.cs_bill_hdemo_sk = hd.hd_demo_sk
WHERE d1.d_year = 2001
  AND d1.d_week_seq = d2.d_week_seq
  AND d3.d_date > d1.d_date + interval '3 day'
  AND i.i_category IN ('Books',
                     'Home',
                     'Sports')
  AND cd.cd_marital_status = 'U'
  AND cd.cd_dep_count BETWEEN 5 AND 7
  AND hd.hd_buy_potential = '1001-5000';