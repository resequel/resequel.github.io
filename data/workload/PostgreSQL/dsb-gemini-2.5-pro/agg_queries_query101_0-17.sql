WITH returns_in_year AS
  (SELECT sr.sr_ticket_number,
          sr.sr_item_sk,
          d1.d_date
   FROM store_returns sr
   JOIN date_dim d1 ON sr.sr_returned_date_sk = d1.d_date_sk
   WHERE d1.d_year = 1999),
     valid_transactions AS
  (SELECT ss.ss_customer_sk,
          ss.ss_item_sk
   FROM store_sales ss
   JOIN returns_in_year riy ON ss.ss_ticket_number = riy.sr_ticket_number
   AND ss.ss_item_sk = riy.sr_item_sk
   JOIN web_sales ws ON ss.ss_customer_sk = ws.ws_bill_customer_sk
   AND ss.ss_item_sk = ws.ws_item_sk
   JOIN date_dim d2 ON ws.ws_sold_date_sk = d2.d_date_sk
   WHERE d2.d_date BETWEEN riy.d_date AND (riy.d_date + interval '90 day')
     AND ss.ss_list_price > 0
     AND ss.ss_sales_price BETWEEN ss.ss_list_price * (80 * 0.01) AND ss.ss_list_price * (100 * 0.01))
SELECT c.c_customer_sk,
       c.c_first_name,
       c.c_last_name,
       count(*) AS cnt
FROM customer c
JOIN valid_transactions vt ON c.c_customer_sk = vt.ss_customer_sk
JOIN item i ON vt.ss_item_sk = i.i_item_sk
AND i.i_category IN ('Books',
                     'Shoes',
                     'Sports')
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
AND ca.ca_state IN ('IN',
                   'MT',
                   'NM',
                   'OH',
                   'OR')
JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
AND hd.hd_income_band_sk BETWEEN 14 AND 20
AND hd.hd_buy_potential = '5001-10000'
GROUP BY c.c_customer_sk,
         c.c_first_name,
         c.c_last_name
ORDER BY cnt;