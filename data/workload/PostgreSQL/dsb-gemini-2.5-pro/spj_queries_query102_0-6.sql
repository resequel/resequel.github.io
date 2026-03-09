
SELECT min(ss_item_sk),
       min(ss_ticket_number),
       min(ws_order_number),
       min(c_customer_sk),
       min(cd_demo_sk),
       min(hd_demo_sk)
FROM date_dim d1,
     date_dim d2,
     item,
     customer_address,
     customer,
     customer_demographics,
     household_demographics,
     store,
     warehouse,
     inventory,
     store_sales,
     web_sales
WHERE ss_item_sk = i_item_sk
  AND ws_item_sk = ss_item_sk
  AND ss_sold_date_sk = d1.d_date_sk
  AND ws_sold_date_sk = d2.d_date_sk
  AND ss_customer_sk = c_customer_sk
  AND ws_bill_customer_sk = c_customer_sk
  AND c_current_addr_sk = ca_address_sk
  AND c_current_cdemo_sk = cd_demo_sk
  AND c_current_hdemo_sk = hd_demo_sk
  AND ss_store_sk = s_store_sk
  AND ws_warehouse_sk = w_warehouse_sk
  AND inv_item_sk = ss_item_sk
  AND inv_date_sk = ss_sold_date_sk
  AND inv_warehouse_sk = ws_warehouse_sk
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
  AND inv_quantity_on_hand >= ss_quantity
  AND s.s_state = w.w_state;