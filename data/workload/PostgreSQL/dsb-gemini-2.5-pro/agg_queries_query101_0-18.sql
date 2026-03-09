
SELECT c.c_customer_sk,
       c.c_first_name,
       c.c_last_name,
       count(*) AS cnt
FROM store_sales ss
JOIN store_returns sr ON ss.ss_ticket_number = sr.sr_ticket_number
AND ss.ss_item_sk = sr.sr_item_sk
JOIN web_sales ws ON ss.ss_customer_sk = ws.ws_bill_customer_sk
AND sr.sr_item_sk = ws.ws_item_sk
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
JOIN date_dim d1 ON sr.sr_returned_date_sk = d1.d_date_sk
JOIN date_dim d2 ON ws.ws_sold_date_sk = d2.d_date_sk
WHERE ss.ss_item_sk IN
    (SELECT i_item_sk
     FROM item
     WHERE i_category IN ('Books',
                     'Shoes',
                     'Sports'))
  AND c.c_current_addr_sk IN
    (SELECT ca_address_sk
     FROM customer_address
     WHERE ca_state IN ('IN',
                   'MT',
                   'NM',
                   'OH',
                   'OR'))
  AND c.c_current_hdemo_sk IN
    (SELECT hd_demo_sk
     FROM household_demographics
     WHERE hd_income_band_sk BETWEEN 14 AND 20
       AND hd_buy_potential = '5001-10000')
  AND d1.d_year = 1999
  AND d2.d_date BETWEEN d1.d_date AND (d1.d_date + interval '90 day')
  AND ss.ss_list_price > 0
  AND ss.ss_sales_price BETWEEN ss.ss_list_price * (80 * 0.01) AND ss.ss_list_price * (100 * 0.01)
GROUP BY c.c_customer_sk,
         c.c_first_name,
         c.c_last_name
ORDER BY cnt;