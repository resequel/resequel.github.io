
SELECT min(ss.ss_item_sk),
       min(ss.ss_ticket_number),
       min(ws.ws_order_number),
       min(c.c_customer_sk),
       min(cd.cd_demo_sk),
       min(hd.hd_demo_sk)
FROM item,
     store_sales ss
JOIN web_sales ws ON ss.ss_item_sk = ws.ws_item_sk
AND ss.ss_customer_sk = ws.ws_bill_customer_sk
JOIN date_dim d1 ON ss.ss_sold_date_sk = d1.d_date_sk
JOIN date_dim d2 ON ws.ws_sold_date_sk = d2.d_date_sk
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN warehouse w ON ws.ws_warehouse_sk = w.w_warehouse_sk
JOIN inventory inv ON inv.inv_item_sk = ss.ss_item_sk
AND inv.inv_warehouse_sk = ws.ws_warehouse_sk
AND inv.inv_date_sk = ss.ss_sold_date_sk
WHERE ss.ss_item_sk = i_item_sk
  AND d1.d_year = 2001
  AND i_category IN ('Books',
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
                       95)
  AND ca_state IN ('IN',
                   'LA',
                   'NE',
                   'NM',
                   'OH')
  AND ws_wholesale_cost BETWEEN 80 AND 100
  AND d2.d_date BETWEEN d1.d_date AND (d1.d_date + interval '30 day')
  AND inv.inv_quantity_on_hand >= ss.ss_quantity
  AND s.s_state = w.w_state;