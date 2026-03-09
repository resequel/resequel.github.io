
SELECT min(w.w_state),
       min(i.i_item_id),
       min(cs.cs_item_sk),
       min(cs.cs_order_number),
       min(cr.cr_item_sk),
       min(cr.cr_order_number)
FROM catalog_sales cs
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
JOIN catalog_returns cr ON cs.cs_order_number = cr.cr_order_number
AND cs.cs_item_sk = cr.cr_item_sk
WHERE cs.cs_wholesale_cost BETWEEN 69 AND 88
  AND cr.cr_reason_sk = 11
  AND i.i_category = 'Home'
  AND i.i_manager_id BETWEEN 28 AND 67
  AND EXISTS
    (SELECT 1
     FROM date_dim d
     WHERE cs.cs_sold_date_sk = d.d_date_sk
       AND d.d_date BETWEEN (CAST('1998-04-26' AS date) - interval '30 day') AND (CAST('1998-04-26' AS date) + interval '30 day'));