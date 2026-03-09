WITH customer_filtered AS
  (SELECT c.c_customer_sk,
          c.c_current_cdemo_sk,
          c.c_current_hdemo_sk
   FROM customer c
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   WHERE ca.ca_state IN ('IN',
                   'LA',
                   'NE',
                   'NM',
                   'OH')),
     item_filtered AS
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
     sales_joined AS
  (SELECT ss.ss_item_sk,
          ss.ss_ticket_number,
          ss.ss_customer_sk,
          ss.ss_quantity,
          ss.ss_store_sk,
          ss.ss_sold_date_sk,
          ws.ws_order_number,
          ws.ws_warehouse_sk,
          ws.ws_sold_date_sk AS ws_date_sk
   FROM store_sales ss
   JOIN web_sales ws ON ss.ss_customer_sk = ws.ws_bill_customer_sk
   AND ss.ss_item_sk = ws.ws_item_sk
   WHERE ws.ws_wholesale_cost BETWEEN 80 AND 100
     AND EXISTS
       (SELECT 1
        FROM item_filtered i
        WHERE i.i_item_sk = ss.ss_item_sk)
     AND EXISTS
       (SELECT 1
        FROM customer_filtered c
        WHERE c.c_customer_sk = ss.ss_customer_sk))
SELECT min(sj.ss_item_sk),
       min(sj.ss_ticket_number),
       min(sj.ws_order_number),
       min(c.c_customer_sk),
       min(cd.cd_demo_sk),
       min(hd.hd_demo_sk)
FROM sales_joined sj
JOIN date_dim d1 ON sj.ss_sold_date_sk = d1.d_date_sk
JOIN date_dim d2 ON sj.ws_date_sk = d2.d_date_sk
JOIN customer_filtered c ON sj.ss_customer_sk = c.c_customer_sk
JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
JOIN store s ON sj.ss_store_sk = s.s_store_sk
JOIN warehouse w ON sj.ws_warehouse_sk = w.w_warehouse_sk
JOIN inventory inv ON inv.inv_item_sk = sj.ss_item_sk
AND inv.inv_warehouse_sk = sj.ws_warehouse_sk
AND inv.inv_date_sk = sj.ss_sold_date_sk
WHERE d1.d_year = 2001
  AND d2.d_date BETWEEN d1.d_date AND (d1.d_date + interval '30 day')
  AND inv.inv_quantity_on_hand >= sj.ss_quantity
  AND s.s_state = w.w_state;