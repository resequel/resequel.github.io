WITH base_data AS
  (SELECT cs.cs_sales_price,
          cr.cr_refunded_cash,
          w.w_state,
          i.i_item_id,
          d.d_date
   FROM catalog_sales cs
   JOIN item i ON cs.cs_item_sk = i.i_item_sk
   JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
   JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
   LEFT JOIN catalog_returns cr ON cs.cs_order_number = cr.cr_order_number
   AND cs.cs_item_sk = cr.cr_item_sk
   AND cr.cr_reason_sk = 11
   WHERE d.d_date BETWEEN (CAST ('1998-04-26' AS date) - interval '30 day') AND (CAST ('1998-04-26' AS date) + interval '30 day')
     AND i.i_category = 'Home'
     AND i.i_manager_id BETWEEN 28 AND 67
     AND cs.cs_wholesale_cost BETWEEN 69 AND 88)
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
FROM base_data
GROUP BY w_state,
         i_item_id
ORDER BY w_state,
         i_item_id
LIMIT 100;