
SELECT c.c_customer_sk,
       c.c_first_name,
       c.c_last_name,
       count(*) AS cnt
FROM customer c
JOIN store_sales ss ON c.c_customer_sk = ss.ss_customer_sk
JOIN store_returns sr ON ss.ss_ticket_number = sr.sr_ticket_number
AND ss.ss_item_sk = sr.sr_item_sk
WHERE ss.ss_list_price > 0
  AND ss.ss_sales_price BETWEEN ss.ss_list_price * (80 * 0.01) AND ss.ss_list_price * (100 * 0.01)
  AND EXISTS
    (SELECT 1
     FROM item i
     WHERE i.i_item_sk = ss.ss_item_sk
       AND i.i_category IN ('Books',
                     'Shoes',
                     'Sports'))
  AND EXISTS
    (SELECT 1
     FROM customer_address ca
     WHERE ca.ca_address_sk = c.c_current_addr_sk
       AND ca.ca_state IN ('IN',
                   'MT',
                   'NM',
                   'OH',
                   'OR'))
  AND EXISTS
    (SELECT 1
     FROM household_demographics hd
     WHERE hd.hd_demo_sk = c.c_current_hdemo_sk
       AND hd.hd_income_band_sk BETWEEN 14 AND 20
       AND hd.hd_buy_potential = '5001-10000')
  AND EXISTS
    (SELECT 1
     FROM web_sales ws
     JOIN date_dim d2 ON ws.ws_sold_date_sk = d2.d_date_sk
     JOIN date_dim d1 ON sr.sr_returned_date_sk = d1.d_date_sk
     WHERE ws.ws_bill_customer_sk = ss.ss_customer_sk
       AND ws.ws_item_sk = sr.sr_item_sk
       AND d1.d_year = 1999
       AND d2.d_date BETWEEN d1.d_date AND (d1.d_date + interval '90 day'))
GROUP BY c.c_customer_sk,
         c.c_first_name,
         c.c_last_name
ORDER BY cnt;