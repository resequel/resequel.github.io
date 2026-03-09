
SELECT min(i.i_item_sk),
       min(w.w_warehouse_name),
       min(d1.d_week_seq),
       min(cs.cs_order_number)
FROM item i,
     warehouse w,
     customer_demographics cd,
     household_demographics hd,
     date_dim d1,
     date_dim d2,
     date_dim d3,
     catalog_sales cs
JOIN inventory inv ON cs.cs_item_sk = inv.inv_item_sk
WHERE cs.cs_sold_date_sk = d1.d_date_sk
  AND cs.cs_item_sk = i.i_item_sk
  AND cs.cs_bill_cdemo_sk = cd.cd_demo_sk
  AND cs.cs_bill_hdemo_sk = hd.hd_demo_sk
  AND inv.inv_date_sk = d2.d_date_sk
  AND inv.inv_warehouse_sk = w.w_warehouse_sk
  AND cs.cs_ship_date_sk = d3.d_date_sk
  AND d1.d_week_seq = d2.d_week_seq
  AND inv.inv_quantity_on_hand < cs.cs_quantity
  AND d3.d_date > d1.d_date + interval '3 day'
  AND hd.hd_buy_potential = '1001-5000'
  AND d1.d_year = 2001
  AND cd.cd_marital_status = 'U'
  AND cd.cd_dep_count BETWEEN 5 AND 7
  AND i.i_category IN ('Books',
                     'Home',
                     'Sports')
  AND cs.cs_wholesale_cost BETWEEN 80 AND 100;