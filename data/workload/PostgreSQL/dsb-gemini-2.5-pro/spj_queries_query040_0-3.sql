WITH filtered_dates AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_date BETWEEN (CAST('1998-04-26' AS date) - interval '30 day') AND (CAST('1998-04-26' AS date) + interval '30 day')),
     filtered_items AS
  (SELECT i_item_sk,
          i_item_id
   FROM item
   WHERE i_category = 'Home'
     AND i_manager_id BETWEEN 28 AND 67),
     filtered_returns AS
  (SELECT cr_order_number,
          cr_item_sk
   FROM catalog_returns
   WHERE cr_reason_sk = 11)
SELECT min(w.w_state),
       min(fi.i_item_id),
       min(cs.cs_item_sk),
       min(cs.cs_order_number),
       min(fr.cr_item_sk),
       min(fr.cr_order_number)
FROM catalog_sales cs
JOIN filtered_dates fd ON cs.cs_sold_date_sk = fd.d_date_sk
JOIN filtered_items fi ON cs.cs_item_sk = fi.i_item_sk
JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
JOIN filtered_returns fr ON cs.cs_order_number = fr.cr_order_number
AND cs.cs_item_sk = fr.cr_item_sk
WHERE cs.cs_wholesale_cost BETWEEN 69 AND 88;