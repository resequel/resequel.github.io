WITH filtered_ss AS
  (SELECT ss_item_sk,
          ss_customer_sk,
          ss_ticket_number
   FROM store_sales
   WHERE ss_list_price > 0
     AND ss_sales_price BETWEEN ss_list_price * (80 * 0.01) AND ss_list_price * (100 * 0.01)),
     filtered_customer AS
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
     AND hd.hd_buy_potential = '5001-10000'),
     filtered_item AS
  (SELECT i_item_sk
   FROM item
   WHERE i_category IN ('Books',
                     'Shoes',
                     'Sports')),
     filtered_d1 AS
  (SELECT d_date_sk,
          d_date
   FROM date_dim
   WHERE d_year = 1999)
SELECT min(fss.ss_customer_sk),
       min(fss.ss_item_sk),
       min(sr.sr_ticket_number),
       min(ws.ws_order_number)
FROM filtered_ss fss
JOIN filtered_customer fc ON fss.ss_customer_sk = fc.c_customer_sk
JOIN filtered_item i ON fss.ss_item_sk = i.i_item_sk
JOIN store_returns sr ON fss.ss_ticket_number = sr.sr_ticket_number
AND fss.ss_item_sk = sr.sr_item_sk
JOIN filtered_d1 d1 ON sr.sr_returned_date_sk = d1.d_date_sk
JOIN web_sales ws ON sr.sr_item_sk = ws.ws_item_sk
AND fss.ss_customer_sk = ws.ws_bill_customer_sk
JOIN date_dim d2 ON ws.ws_sold_date_sk = d2.d_date_sk
WHERE d2.d_date BETWEEN d1.d_date AND (d1.d_date + interval '90 day');