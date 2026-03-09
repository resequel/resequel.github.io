WITH filtered_date AS
  (SELECT d_date_sk,
          d_date
   FROM date_dim
   WHERE d_date BETWEEN (CAST ('1998-04-26' AS date) - interval '30 day') AND (CAST ('1998-04-26' AS date) + interval '30 day')),
     filtered_item AS
  (SELECT i_item_sk,
          i_item_id
   FROM item
   WHERE i_category = 'Home'
     AND i_manager_id BETWEEN 28 AND 67)
SELECT w_state,
       fi.i_item_id,
       sum(CASE
               WHEN (cast(fd.d_date AS date) < CAST ('1998-04-26' AS date)) THEN cs_sales_price - coalesce(cr_refunded_cash, 0)
               ELSE 0
           END) AS sales_before,
       sum(CASE
               WHEN (cast(fd.d_date AS date) >= CAST ('1998-04-26' AS date)) THEN cs_sales_price - coalesce(cr_refunded_cash, 0)
               ELSE 0
           END) AS sales_after
FROM catalog_sales
JOIN filtered_item fi ON cs_item_sk = fi.i_item_sk
JOIN warehouse ON cs_warehouse_sk = w_warehouse_sk
JOIN filtered_date fd ON cs_sold_date_sk = fd.d_date_sk
LEFT JOIN catalog_returns cr ON cs_order_number = cr.cr_order_number
AND cs_item_sk = cr.cr_item_sk
AND cr.cr_reason_sk = 11
WHERE cs_wholesale_cost BETWEEN 69 AND 88
GROUP BY w_state,
         fi.i_item_id
ORDER BY w_state,
         fi.i_item_id
LIMIT 100;