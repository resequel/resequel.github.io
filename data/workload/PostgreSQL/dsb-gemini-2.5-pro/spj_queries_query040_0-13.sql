
SELECT min(w_state),
       min(i_item_id),
       min(cs_item_sk),
       min(cs_order_number),
       min(cr_item_sk),
       min(cr_order_number)
FROM item i,
     warehouse w,
     date_dim d,
     catalog_sales cs
INNER JOIN catalog_returns cr ON cs.cs_order_number = cr.cr_order_number
AND cs.cs_item_sk = cr.cr_item_sk
WHERE cs.cs_item_sk = i.i_item_sk
  AND cs.cs_warehouse_sk = w.w_warehouse_sk
  AND cs.cs_sold_date_sk = d.d_date_sk
  AND d.d_date BETWEEN (CAST('1998-04-26' AS date) - interval '30 day') AND (CAST('1998-04-26' AS date) + interval '30 day')
  AND i.i_category = 'Home'
  AND i.i_manager_id BETWEEN 28 AND 67
  AND cs.cs_wholesale_cost BETWEEN 69 AND 88
  AND cr.cr_reason_sk = 11;