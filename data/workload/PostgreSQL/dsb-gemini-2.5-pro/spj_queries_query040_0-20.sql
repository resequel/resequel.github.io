WITH step1 AS
  (SELECT cs.cs_item_sk,
          cs.cs_order_number,
          cs.cs_warehouse_sk
   FROM catalog_sales cs
   JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
   WHERE cs.cs_wholesale_cost BETWEEN 69 AND 88
     AND d.d_date BETWEEN (CAST('1998-04-26' AS date) - interval '30 day') AND (CAST('1998-04-26' AS date) + interval '30 day')),
     step2 AS
  (SELECT s1.cs_item_sk,
          s1.cs_order_number,
          s1.cs_warehouse_sk,
          i.i_item_id
   FROM step1 s1
   JOIN item i ON s1.cs_item_sk = i.i_item_sk
   WHERE i.i_category = 'Home'
     AND i.i_manager_id BETWEEN 28 AND 67)
SELECT min(w.w_state),
       min(s2.i_item_id),
       min(s2.cs_item_sk),
       min(s2.cs_order_number),
       min(cr.cr_item_sk),
       min(cr.cr_order_number)
FROM step2 s2
JOIN warehouse w ON s2.cs_warehouse_sk = w.w_warehouse_sk
JOIN catalog_returns cr ON s2.cs_order_number = cr.cr_order_number
AND s2.cs_item_sk = cr.cr_item_sk
WHERE cr.cr_reason_sk = 11;