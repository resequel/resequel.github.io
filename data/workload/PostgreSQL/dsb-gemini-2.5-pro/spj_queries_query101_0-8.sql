
SELECT min(c.c_customer_sk),
       min(ss.ss_item_sk),
       min(sr.sr_ticket_number),
       min(ws.ws_order_number)
FROM
  (SELECT ss_ticket_number,
          ss_item_sk,
          ss_customer_sk
   FROM store_sales
   WHERE ss_list_price > 0
     AND ss_sales_price BETWEEN (ss_list_price * 80 * 0.01) AND (ss_list_price * 100 * 0.01)) AS ss
JOIN
  (SELECT sr_ticket_number,
          sr_item_sk,
          d1.d_date
   FROM store_returns
   JOIN date_dim d1 ON sr_returned_date_sk = d1.d_date_sk
   WHERE d1.d_year = 1999) AS sr ON ss.ss_ticket_number = sr.sr_ticket_number
AND ss.ss_item_sk = sr.sr_item_sk
JOIN
  (SELECT ws_order_number,
          ws_item_sk,
          ws_bill_customer_sk,
          d2.d_date
   FROM web_sales
   JOIN date_dim d2 ON ws_sold_date_sk = d2.d_date_sk) AS ws ON ss.ss_customer_sk = ws.ws_bill_customer_sk
AND ss.ss_item_sk = ws.ws_item_sk
JOIN
  (SELECT i_item_sk
   FROM item
   WHERE i_category IN ('Books',
                     'Shoes',
                     'Sports')) AS i ON ss.ss_item_sk = i.i_item_sk
JOIN
  (SELECT c.c_customer_sk
   FROM customer c
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
   WHERE ca.ca_state IN ('IN',
                   'MT',
                   'NM',
                   'OH',
                   'OR')
     AND hd.hd_income_band_sk BETWEEN 14 AND 20
     AND hd.hd_buy_potential = '5001-10000') AS c ON ss.ss_customer_sk = c.c_customer_sk
WHERE ws.d_date BETWEEN sr.d_date AND (sr.d_date + interval '90 day');