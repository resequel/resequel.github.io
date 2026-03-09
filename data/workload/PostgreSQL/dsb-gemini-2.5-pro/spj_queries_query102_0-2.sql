WITH filtered_item AS
  (SELECT i_item_sk
   FROM item
   WHERE i_category IN ('Books',
                     'Home',
                     'Sports')
     AND i_manager_id IN (3,
                       15,
                       17,
                       26,
                       43,
                       44,
                       55,
                       70,
                       82,
                       95)),
     filtered_customer AS
  (SELECT c.c_customer_sk,
          c.c_current_cdemo_sk,
          c.c_current_hdemo_sk
   FROM customer
   JOIN customer_address ON c_current_addr_sk = ca_address_sk
   WHERE ca_state IN ('IN',
                   'LA',
                   'NE',
                   'NM',
                   'OH')),
     filtered_date1 AS
  (SELECT d_date_sk,
          d_date
   FROM date_dim
   WHERE d_year = 2001)
SELECT min(ss.ss_item_sk),
       min(ss.ss_ticket_number),
       min(ws.ws_order_number),
       min(c.c_customer_sk),
       min(c.c_current_cdemo_sk),
       min(c.c_current_hdemo_sk)
FROM web_sales ws
JOIN filtered_item fi ON ws.ws_item_sk = fi.i_item_sk
JOIN filtered_customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
JOIN store_sales ss ON ws.ws_item_sk = ss.ss_item_sk
AND ws.ws_bill_customer_sk = ss.ss_customer_sk
JOIN filtered_date1 d1 ON ss.ss_sold_date_sk = d1.d_date_sk
JOIN date_dim d2 ON ws.ws_sold_date_sk = d2.d_date_sk
JOIN inventory inv ON ws.ws_item_sk = inv.inv_item_sk
AND ss.ss_sold_date_sk = inv.inv_date_sk
AND ws.ws_warehouse_sk = inv.inv_warehouse_sk
JOIN warehouse w ON ws.ws_warehouse_sk = w.w_warehouse_sk
WHERE ws.ws_wholesale_cost BETWEEN 80 AND 100
  AND d2.d_date BETWEEN d1.d_date AND (d1.d_date + interval '30 day')
  AND inv.inv_quantity_on_hand >= ss.ss_quantity
  AND EXISTS
    (SELECT 1
     FROM store s
     WHERE s.s_state = w.w_state);