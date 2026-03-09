
SELECT min(c.c_customer_sk),
       min(i.i_item_sk),
       min(sr.sr_ticket_number),
       min(ws.ws_order_number)
FROM item AS i
JOIN store_sales AS ss ON i.i_item_sk = ss.ss_item_sk
JOIN store_returns AS sr ON ss.ss_ticket_number = sr.sr_ticket_number
AND ss.ss_item_sk = sr.sr_item_sk
JOIN date_dim AS d1 ON sr.sr_returned_date_sk = d1.d_date_sk
JOIN customer AS c ON ss.ss_customer_sk = c.c_customer_sk
JOIN customer_address AS ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN household_demographics AS hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
JOIN web_sales AS ws ON c.c_customer_sk = ws.ws_bill_customer_sk
AND i.i_item_sk = ws.ws_item_sk
JOIN date_dim AS d2 ON ws.ws_sold_date_sk = d2.d_date_sk
WHERE i.i_category IN ('Books',
                     'Shoes',
                     'Sports')
  AND d1.d_year = 1999
  AND ca.ca_state IN ('IN',
                   'MT',
                   'NM',
                   'OH',
                   'OR')
  AND hd.hd_income_band_sk BETWEEN 14 AND 20
  AND hd.hd_buy_potential = '5001-10000'
  AND ss.ss_list_price > 0
  AND ss.ss_sales_price BETWEEN (ss.ss_list_price * 80 * 0.01) AND (ss.ss_list_price * 100 * 0.01)
  AND d2.d_date BETWEEN d1.d_date AND (d1.d_date + interval '90 day');