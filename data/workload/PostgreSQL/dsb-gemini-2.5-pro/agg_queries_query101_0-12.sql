WITH filtered_d1 AS
  (SELECT d_date_sk,
          d_date
   FROM date_dim
   WHERE d_year = 1999),
     eligible_customers AS
  (SELECT c.c_customer_sk,
          c.c_first_name,
          c.c_last_name
   FROM customer c
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   AND ca.ca_state IN ('IN',
                   'MT',
                   'NM',
                   'OH',
                   'OR')
   JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
   AND hd.hd_income_band_sk BETWEEN 14 AND 20
   AND hd.hd_buy_potential = '5001-10000')
SELECT ec.c_customer_sk,
       ec.c_first_name,
       ec.c_last_name,
       count(*) AS cnt
FROM eligible_customers ec
JOIN store_sales ss ON ec.c_customer_sk = ss.ss_customer_sk
JOIN store_returns sr ON ss.ss_ticket_number = sr.sr_ticket_number
AND ss.ss_item_sk = sr.sr_item_sk
JOIN web_sales ws ON ss.ss_customer_sk = ws.ws_bill_customer_sk
AND ss.ss_item_sk = ws.ws_item_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
AND i.i_category IN ('Books',
                     'Shoes',
                     'Sports')
JOIN filtered_d1 d1 ON sr.sr_returned_date_sk = d1.d_date_sk
JOIN date_dim d2 ON ws.ws_sold_date_sk = d2.d_date_sk
WHERE d2.d_date BETWEEN d1.d_date AND (d1.d_date + interval '90 day')
  AND ss.ss_list_price > 0
  AND ss.ss_sales_price BETWEEN ss.ss_list_price * (80 * 0.01) AND ss.ss_list_price * (100 * 0.01)
GROUP BY ec.c_customer_sk,
         ec.c_first_name,
         ec.c_last_name
ORDER BY cnt;