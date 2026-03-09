
SELECT w_state,
       i_item_id,
       sum(CASE
               WHEN (cast(d_date AS date) < CAST ('1998-04-26' AS date)) THEN cs_sales_price - coalesce(cr_refunded_cash, 0)
               ELSE 0
           END) AS sales_before,
       sum(CASE
               WHEN (cast(d_date AS date) >= CAST ('1998-04-26' AS date)) THEN cs_sales_price - coalesce(cr_refunded_cash, 0)
               ELSE 0
           END) AS sales_after
FROM item
JOIN catalog_sales ON i_item_sk = cs_item_sk
JOIN date_dim ON cs_sold_date_sk = d_date_sk
JOIN warehouse ON cs_warehouse_sk = w_warehouse_sk
LEFT JOIN catalog_returns ON cs_order_number = cr_order_number
AND cs_item_sk = cr_item_sk
AND cr_reason_sk = 11
WHERE d_date BETWEEN (CAST ('1998-04-26' AS date) - interval '30 day') AND (CAST ('1998-04-26' AS date) + interval '30 day')
  AND i_category = 'Home'
  AND i_manager_id BETWEEN 28 AND 67
  AND cs_wholesale_cost BETWEEN 69 AND 88
GROUP BY w_state,
         i_item_id
ORDER BY w_state,
         i_item_id
LIMIT 100;