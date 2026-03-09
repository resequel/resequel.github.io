WITH sales_data AS
  (SELECT cs.cs_sales_price,
          cs.cs_order_number,
          cs.cs_item_sk,
          w.w_state,
          i.i_item_id,
          d.d_date
   FROM catalog_sales cs
   JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
   JOIN item i ON cs.cs_item_sk = i.i_item_sk
   JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
   WHERE d.d_date BETWEEN (CAST ('1998-04-26' AS date) - interval '30 day') AND (CAST ('1998-04-26' AS date) + interval '30 day')
     AND i.i_category = 'Home'
     AND i.i_manager_id BETWEEN 28 AND 67
     AND cs.cs_wholesale_cost BETWEEN 69 AND 88)
SELECT sd.w_state,
       sd.i_item_id,
       sum(CASE
               WHEN (cast(sd.d_date AS date) < CAST ('1998-04-26' AS date)) THEN sd.cs_sales_price - coalesce(cr.cr_refunded_cash, 0)
               ELSE 0
           END) AS sales_before,
       sum(CASE
               WHEN (cast(sd.d_date AS date) >= CAST ('1998-04-26' AS date)) THEN sd.cs_sales_price - coalesce(cr.cr_refunded_cash, 0)
               ELSE 0
           END) AS sales_after
FROM sales_data sd
LEFT JOIN catalog_returns cr ON sd.cs_order_number = cr.cr_order_number
AND sd.cs_item_sk = cr.cr_item_sk
AND cr.cr_reason_sk = 11
GROUP BY sd.w_state,
         sd.i_item_id
ORDER BY sd.w_state,
         sd.i_item_id
LIMIT 100;