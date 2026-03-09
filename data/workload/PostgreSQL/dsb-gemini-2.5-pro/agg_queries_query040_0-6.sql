WITH sales_keys AS
  (SELECT cs_sales_price,
          cs_order_number,
          cs_item_sk,
          cs_warehouse_sk,
          cs_sold_date_sk
   FROM catalog_sales
   WHERE cs_wholesale_cost BETWEEN 69 AND 88),
     item_keys AS
  (SELECT i_item_sk,
          i_item_id
   FROM item
   WHERE i_category = 'Home'
     AND i_manager_id BETWEEN 28 AND 67),
     date_keys AS
  (SELECT d_date_sk,
          d_date
   FROM date_dim
   WHERE d_date BETWEEN (CAST ('1998-04-26' AS date) - interval '30 day') AND (CAST ('1998-04-26' AS date) + interval '30 day'))
SELECT w.w_state,
       ik.i_item_id,
       sum(CASE
               WHEN (cast(dk.d_date AS date) < CAST ('1998-04-26' AS date)) THEN sk.cs_sales_price - coalesce(cr.cr_refunded_cash, 0)
               ELSE 0
           END) AS sales_before,
       sum(CASE
               WHEN (cast(dk.d_date AS date) >= CAST ('1998-04-26' AS date)) THEN sk.cs_sales_price - coalesce(cr.cr_refunded_cash, 0)
               ELSE 0
           END) AS sales_after
FROM sales_keys sk
JOIN item_keys ik ON sk.cs_item_sk = ik.i_item_sk
JOIN date_keys dk ON sk.cs_sold_date_sk = dk.d_date_sk
JOIN warehouse w ON sk.cs_warehouse_sk = w.w_warehouse_sk
LEFT JOIN catalog_returns cr ON sk.cs_order_number = cr.cr_order_number
AND sk.cs_item_sk = cr.cr_item_sk
AND cr.cr_reason_sk = 11
GROUP BY w.w_state,
         ik.i_item_id
ORDER BY w.w_state,
         ik.i_item_id
LIMIT 100;