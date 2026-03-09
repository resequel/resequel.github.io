WITH relevant_returns AS
  (SELECT cr_order_number,
          cr_item_sk,
          cr_refunded_cash
   FROM catalog_returns
   WHERE cr_reason_sk = 11)
SELECT w_state,
       i_item_id,
       sum(CASE
               WHEN (cast(d_date AS date) < CAST ('1998-04-26' AS date)) THEN cs_sales_price - coalesce(rr.cr_refunded_cash, 0)
               ELSE 0
           END) AS sales_before,
       sum(CASE
               WHEN (cast(d_date AS date) >= CAST ('1998-04-26' AS date)) THEN cs_sales_price - coalesce(rr.cr_refunded_cash, 0)
               ELSE 0
           END) AS sales_after
FROM catalog_sales
JOIN item ON cs_item_sk = i_item_sk
JOIN warehouse ON cs_warehouse_sk = w_warehouse_sk
JOIN date_dim ON cs_sold_date_sk = d_date_sk
LEFT JOIN relevant_returns rr ON cs_order_number = rr.cr_order_number
AND cs_item_sk = rr.cr_item_sk
WHERE d_date BETWEEN (CAST ('1998-04-26' AS date) - interval '30 day') AND (CAST ('1998-04-26' AS date) + interval '30 day')
  AND i_category = 'Home'
  AND i_manager_id BETWEEN 28 AND 67
  AND cs_wholesale_cost BETWEEN 69 AND 88
GROUP BY w_state,
         i_item_id
ORDER BY w_state,
         i_item_id
LIMIT 100;