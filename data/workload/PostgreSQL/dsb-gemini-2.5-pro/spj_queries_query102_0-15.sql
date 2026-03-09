WITH sales_channel_join AS
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
   JOIN web_sales ws ON ss.ss_item_sk = ws.ws_item_sk
   AND ss.ss_customer_sk = ws.ws_bill_customer_sk
   WHERE ws.ws_wholesale_cost BETWEEN 80 AND 100)
SELECT min(scj.ss_item_sk),
       min(scj.ss_ticket_number),
       min(scj.ws_order_number),
       min(c.c_customer_sk),
       min(cd.cd_demo_sk),
       min(hd.hd_demo_sk)
FROM sales_channel_join scj
JOIN item i ON scj.ss_item_sk = i.i_item_sk
JOIN customer c ON scj.ss_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN date_dim d1 ON scj.ss_sold_date_sk = d1.d_date_sk
JOIN date_dim d2 ON scj.ws_date_sk = d2.d_date_sk
JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
JOIN store s ON scj.ss_store_sk = s.s_store_sk
JOIN warehouse w ON scj.ws_warehouse_sk = w.w_warehouse_sk
JOIN inventory inv ON inv.inv_item_sk = scj.ss_item_sk
AND inv.inv_warehouse_sk = scj.ws_warehouse_sk
AND inv.inv_date_sk = scj.ss_sold_date_sk
WHERE i.i_category IN ('Books',
                     'Home',
                     'Sports')
  AND i.i_manager_id IN (3,
                       15,
                       17,
                       26,
                       43,
                       44,
                       55,
                       70,
                       82,
                       95)
  AND ca.ca_state IN ('IN',
                   'LA',
                   'NE',
                   'NM',
                   'OH')
  AND d1.d_year = 2001
  AND d2.d_date BETWEEN d1.d_date AND (d1.d_date + interval '30 day')
  AND inv.inv_quantity_on_hand >= scj.ss_quantity
  AND s.s_state = w.w_state;