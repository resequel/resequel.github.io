WITH sales_data AS
  (SELECT ss.ss_customer_sk,
          ss.ss_item_sk,
          sr.sr_ticket_number,
          ws.ws_order_number,
          d1.d_date AS return_date,
          d2.d_date AS sold_date
   FROM store_sales ss
   JOIN store_returns sr ON ss.ss_ticket_number = sr.sr_ticket_number
   AND ss.ss_item_sk = sr.sr_item_sk
   JOIN web_sales ws ON ss.ss_customer_sk = ws.ws_bill_customer_sk
   AND ss.ss_item_sk = ws.ws_item_sk
   JOIN date_dim d1 ON sr.sr_returned_date_sk = d1.d_date_sk
   JOIN date_dim d2 ON ws.ws_sold_date_sk = d2.d_date_sk
   WHERE ss.ss_list_price > 0
     AND ss.ss_sales_price BETWEEN (ss.ss_list_price * 80 * 0.01) AND (ss.ss_list_price * 100 * 0.01)
     AND d1.d_year = 1999)
SELECT min(s.ss_customer_sk),
       min(s.ss_item_sk),
       min(s.sr_ticket_number),
       min(s.ws_order_number)
FROM sales_data s
JOIN customer c ON s.ss_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
JOIN item i ON s.ss_item_sk = i.i_item_sk
WHERE s.sold_date BETWEEN s.return_date AND (s.return_date + interval '90 day')
  AND ca.ca_state IN ('IN',
                   'MT',
                   'NM',
                   'OH',
                   'OR')
  AND hd.hd_income_band_sk BETWEEN 14 AND 20
  AND hd.hd_buy_potential = '5001-10000'
  AND i.i_category IN ('Books',
                     'Shoes',
                     'Sports');