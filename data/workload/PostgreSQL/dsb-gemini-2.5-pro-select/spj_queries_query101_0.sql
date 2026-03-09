
SELECT min(c_customer_sk),
       min(ss_item_sk),
       min(sr_ticket_number),
       min(ws_order_number)
FROM store_sales
JOIN store_returns ON ss_ticket_number = sr_ticket_number
AND ss_item_sk = sr_item_sk
JOIN web_sales ON ss_customer_sk = ws_bill_customer_sk
AND sr_item_sk = ws_item_sk
JOIN date_dim d1 ON sr_returned_date_sk = d1.d_date_sk
JOIN date_dim d2 ON ws_sold_date_sk = d2.d_date_sk
JOIN item ON i_item_sk = ss_item_sk
JOIN customer ON ss_customer_sk = c_customer_sk
JOIN customer_address ON c_current_addr_sk = ca_address_sk
JOIN household_demographics ON c_current_hdemo_sk = hd_demo_sk
WHERE i_category IN ('Books',
                     'Shoes',
                     'Sports')
  AND d2.d_date BETWEEN d1.d_date AND (d1.d_date + interval '90 day')
  AND ca_state IN ('IN',
                   'MT',
                   'NM',
                   'OH',
                   'OR')
  AND d1.d_year = 1999
  AND hd_income_band_sk BETWEEN 14 AND 20
  AND hd_buy_potential = '5001-10000'
  AND ss_list_price > 0
  AND ss_sales_price BETWEEN (ss_list_price * 80 * 0.01) AND (ss_list_price * 100 * 0.01);