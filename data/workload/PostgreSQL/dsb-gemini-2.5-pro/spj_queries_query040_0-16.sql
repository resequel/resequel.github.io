WITH all_data AS
  (SELECT w.w_state,
          i.i_item_id,
          cs.cs_item_sk,
          cs.cs_order_number,
          cr.cr_item_sk,
          cr.cr_order_number
   FROM catalog_sales cs
   JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
   JOIN item i ON cs.cs_item_sk = i.i_item_sk
   JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
   JOIN catalog_returns cr ON cs.cs_order_number = cr.cr_order_number
   AND cs.cs_item_sk = cr.cr_item_sk
   WHERE d.d_date BETWEEN (CAST('1998-04-26' AS date) - interval '30 day') AND (CAST('1998-04-26' AS date) + interval '30 day')
     AND i.i_category = 'Home'
     AND i.i_manager_id BETWEEN 28 AND 67
     AND cs.cs_wholesale_cost BETWEEN 69 AND 88
     AND cr.cr_reason_sk = 11)
SELECT min(w_state),
       min(i_item_id),
       min(cs_item_sk),
       min(cs_order_number),
       min(cr_item_sk),
       min(cr_order_number)
FROM all_data;