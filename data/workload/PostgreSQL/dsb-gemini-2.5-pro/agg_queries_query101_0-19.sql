WITH filtered_returns AS
  (SELECT sr_ticket_number,
          sr_item_sk,
          d_date
   FROM store_returns
   JOIN date_dim ON sr_returned_date_sk = d_date_sk
   WHERE d_year = 1999),
     filtered_web_sales AS
  (SELECT ws_bill_customer_sk,
          ws_item_sk,
          d_date
   FROM web_sales
   JOIN date_dim ON ws_sold_date_sk = d_date_sk)
SELECT c.c_customer_sk,
       c.c_first_name,
       c.c_last_name,
       count(*) AS cnt
FROM store_sales ss
JOIN filtered_returns fr ON ss.ss_ticket_number = fr.sr_ticket_number
AND ss.ss_item_sk = fr.sr_item_sk
JOIN filtered_web_sales fws ON ss.ss_customer_sk = fws.ws_bill_customer_sk
AND ss.ss_item_sk = fws.ws_item_sk
JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
WHERE fws.d_date BETWEEN fr.d_date AND (fr.d_date + interval '90 day')
  AND ca.ca_state IN ('IN',
                   'MT',
                   'NM',
                   'OH',
                   'OR')
  AND hd.hd_income_band_sk BETWEEN 14 AND 20
  AND hd.hd_buy_potential = '5001-10000'
  AND i.i_category IN ('Books',
                     'Shoes',
                     'Sports')
  AND ss.ss_list_price > 0
  AND ss.ss_sales_price BETWEEN ss.ss_list_price * (80 * 0.01) AND ss.ss_list_price * (100 * 0.01)
GROUP BY c.c_customer_sk,
         c.c_first_name,
         c.c_last_name
ORDER BY cnt;