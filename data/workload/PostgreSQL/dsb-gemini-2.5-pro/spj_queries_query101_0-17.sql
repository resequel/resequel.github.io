WITH customer_info AS
  (SELECT c.c_customer_sk
   FROM customer AS c
   JOIN customer_address AS ca ON c.c_current_addr_sk = ca.ca_address_sk
   JOIN household_demographics AS hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
   WHERE ca.ca_state IN ('IN',
                   'MT',
                   'NM',
                   'OH',
                   'OR')
     AND hd.hd_income_band_sk BETWEEN 14 AND 20
     AND hd.hd_buy_potential = '5001-10000'),
     returns_info AS
  (SELECT sr.sr_ticket_number,
          sr.sr_item_sk,
          d1.d_date
   FROM store_returns AS sr
   JOIN date_dim AS d1 ON sr.sr_returned_date_sk = d1.d_date_sk
   WHERE d1.d_year = 1999)
SELECT min(ss.ss_customer_sk),
       min(ss.ss_item_sk),
       min(ri.sr_ticket_number),
       min(ws.ws_order_number)
FROM store_sales AS ss
JOIN item AS i ON ss.ss_item_sk = i.i_item_sk
JOIN customer_info AS ci ON ss.ss_customer_sk = ci.c_customer_sk
JOIN returns_info AS ri ON ss.ss_ticket_number = ri.sr_ticket_number
AND ss.ss_item_sk = ri.sr_item_sk
JOIN web_sales AS ws ON ss.ss_customer_sk = ws.ws_bill_customer_sk
AND ss.ss_item_sk = ws.ws_item_sk
JOIN date_dim AS d2 ON ws.ws_sold_date_sk = d2.d_date_sk
WHERE i.i_category IN ('Books',
                     'Shoes',
                     'Sports')
  AND ss.ss_list_price > 0
  AND ss.ss_sales_price BETWEEN (ss.ss_list_price * 80 * 0.01) AND (ss.ss_list_price * 100 * 0.01)
  AND d2.d_date BETWEEN ri.d_date AND (ri.d_date + interval '90 day');