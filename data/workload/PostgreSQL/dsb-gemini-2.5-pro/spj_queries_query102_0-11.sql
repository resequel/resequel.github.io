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
     store_sales_base AS
  (SELECT ss.ss_item_sk,
          ss.ss_ticket_number,
          ss.ss_customer_sk,
          ss.ss_sold_date_sk,
          ss.ss_quantity,
          d1.d_date,
          c.c_current_cdemo_sk,
          c.c_current_hdemo_sk
   FROM store_sales ss
   JOIN date_dim d1 ON ss.ss_sold_date_sk = d1.d_date_sk
   AND d1.d_year = 2001
   JOIN filtered_customer c ON ss.ss_customer_sk = c.c_customer_sk
   JOIN filtered_item fi ON ss.ss_item_sk = fi.i_item_sk),
     web_sales_base AS
  (SELECT ws.ws_item_sk,
          ws.ws_order_number,
          ws.ws_bill_customer_sk,
          ws.ws_sold_date_sk,
          ws.ws_warehouse_sk
   FROM web_sales ws
   WHERE ws.ws_wholesale_cost BETWEEN 80 AND 100)
SELECT min(ssb.ss_item_sk),
       min(ssb.ss_ticket_number),
       min(wsb.ws_order_number),
       min(ssb.ss_customer_sk),
       min(ssb.c_current_cdemo_sk),
       min(ssb.c_current_hdemo_sk)
FROM store_sales_base ssb
JOIN web_sales_base wsb ON ssb.ss_item_sk = wsb.ws_item_sk
AND ssb.ss_customer_sk = wsb.ws_bill_customer_sk
JOIN date_dim d2 ON wsb.ws_sold_date_sk = d2.d_date_sk
JOIN inventory inv ON ssb.ss_item_sk = inv.inv_item_sk
AND ssb.ss_sold_date_sk = inv.inv_date_sk
AND wsb.ws_warehouse_sk = inv.inv_warehouse_sk
JOIN warehouse w ON wsb.ws_warehouse_sk = w.w_warehouse_sk
WHERE d2.d_date BETWEEN ssb.d_date AND (ssb.d_date + interval '30 day')
  AND inv.inv_quantity_on_hand >= ssb.ss_quantity
  AND EXISTS
    (SELECT 1
     FROM store s
     WHERE s.s_state = w.w_state);