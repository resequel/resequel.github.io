WITH filtered_ss_sr AS
  (SELECT ss.ss_item_sk,
          ss.ss_customer_sk,
          ss.ss_ticket_number,
          sr.sr_ticket_number AS sr_ticket_num,
          sr.sr_item_sk AS sr_item_num,
          sr.sr_returned_date_sk
   FROM store_sales ss
   JOIN store_returns sr ON ss.ss_ticket_number = sr.sr_ticket_number
   AND ss.ss_item_sk = sr.ss_item_sk
   WHERE ss.ss_list_price > 0
     AND ss.ss_sales_price BETWEEN ss.ss_list_price * (80 * 0.01) AND ss.ss_list_price * (100 * 0.01))
SELECT min(c.c_customer_sk),
       min(f.ss_item_sk),
       min(f.sr_ticket_num),
       min(ws.ws_order_number)
FROM filtered_ss_sr f
JOIN web_sales ws ON f.sr_item_num = ws.ws_item_sk
AND f.ss_customer_sk = ws.ws_bill_customer_sk
JOIN date_dim d1 ON f.sr_returned_date_sk = d1.d_date_sk
JOIN date_dim d2 ON ws.ws_sold_date_sk = d2.d_date_sk
JOIN item i ON f.ss_item_sk = i.i_item_sk
JOIN customer c ON f.ss_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
WHERE d1.d_year = 1999
  AND d2.d_date BETWEEN d1.d_date AND (d1.d_date + interval '90 day')
  AND i.i_category IN ('Books',
                     'Shoes',
                     'Sports')
  AND ca.ca_state IN ('IN',
                   'MT',
                   'NM',
                   'OH',
                   'OR')
  AND hd.hd_income_band_sk BETWEEN 14 AND 20
  AND hd.hd_buy_potential = '5001-10000';