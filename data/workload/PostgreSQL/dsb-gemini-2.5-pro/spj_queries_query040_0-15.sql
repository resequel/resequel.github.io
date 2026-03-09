WITH returned_sales AS
  (SELECT cs.cs_sold_date_sk,
          cs.cs_item_sk,
          cs.cs_warehouse_sk,
          cs.cs_order_number,
          cr.cr_item_sk AS cr_item_sk_ret,
          cr.cr_order_number AS cr_order_number_ret
   FROM catalog_sales cs
   JOIN catalog_returns cr ON cs.cs_order_number = cr.cr_order_number
   AND cs.cs_item_sk = cr.cr_item_sk
   WHERE cs.cs_wholesale_cost BETWEEN 69 AND 88
     AND cr.cr_reason_sk = 11)
SELECT min(w.w_state),
       min(i.i_item_id),
       min(rs.cs_item_sk),
       min(rs.cs_order_number),
       min(rs.cr_item_sk_ret),
       min(rs.cr_order_number_ret)
FROM returned_sales rs
JOIN date_dim d ON rs.cs_sold_date_sk = d.d_date_sk
JOIN item i ON rs.cs_item_sk = i.i_item_sk
JOIN warehouse w ON rs.cs_warehouse_sk = w.w_warehouse_sk
WHERE d.d_date BETWEEN (CAST('1998-04-26' AS date) - interval '30 day') AND (CAST('1998-04-26' AS date) + interval '30 day')
  AND i.i_category = 'Home'
  AND i.i_manager_id BETWEEN 28 AND 67;