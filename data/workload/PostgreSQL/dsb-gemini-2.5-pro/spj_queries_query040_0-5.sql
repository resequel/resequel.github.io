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
     date_item_keys AS
  (SELECT fd.d_date_sk,
          fi.i_item_sk,
          fi.i_item_id
   FROM filtered_dates fd,
        filtered_items fi)
SELECT min(w.w_state),
       min(dik.i_item_id),
       min(cs.cs_item_sk),
       min(cs.cs_order_number),
       min(cr.cr_item_sk),
       min(cr.cr_order_number)
FROM catalog_sales cs
JOIN date_item_keys dik ON cs.cs_sold_date_sk = dik.d_date_sk
AND cs.cs_item_sk = dik.i_item_sk
JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
JOIN catalog_returns cr ON cs.cs_order_number = cr.cr_order_number
AND cs.cs_item_sk = cr.cr_item_sk
WHERE cs.cs_wholesale_cost BETWEEN 69 AND 88
  AND cr.cr_reason_sk = 11;