WITH customers_of_interest AS
  (SELECT c.c_customer_sk
   FROM customer c
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   AND ca.ca_state IN ('IN',
                   'MT',
                   'NM',
                   'OH',
                   'OR')
   JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
   AND hd.hd_income_band_sk BETWEEN 14 AND 20
   AND hd.hd_buy_potential = '5001-10000'),
     ss_of_interest AS
  (SELECT ss.ss_ticket_number,
          ss.ss_item_sk,
          ss.ss_customer_sk
   FROM store_sales ss
   JOIN customers_of_interest coi ON ss.ss_customer_sk = coi.c_customer_sk
   WHERE ss.ss_list_price > 0
     AND ss.ss_sales_price BETWEEN (ss.ss_list_price * 80 * 0.01) AND (ss.ss_list_price * 100 * 0.01))
SELECT min(ss.ss_customer_sk),
       min(ss.ss_item_sk),
       min(sr.sr_ticket_number),
       min(ws.ws_order_number)
FROM ss_of_interest ss
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN store_returns sr ON ss.ss_ticket_number = sr.sr_ticket_number
AND ss.ss_item_sk = i.i_item_sk
JOIN date_dim d1 ON sr.sr_returned_date_sk = d1.d_date_sk
JOIN web_sales ws ON ss.ss_customer_sk = ws.ws_bill_customer_sk
AND ss.ss_item_sk = i.i_item_sk
JOIN date_dim d2 ON ws.ws_sold_date_sk = d2.d_date_sk
WHERE i.i_category IN ('Books',
                     'Shoes',
                     'Sports')
  AND d1.d_year = 1999
  AND d2.d_date BETWEEN d1.d_date AND (d1.d_date + interval '90 day');