WITH filtered_customers AS
  (SELECT c_customer_sk,
          c_first_name,
          c_last_name
   FROM customer
   JOIN customer_address ON c_current_addr_sk = ca_address_sk
   JOIN household_demographics ON c_current_hdemo_sk = hd_demo_sk
   WHERE ca_state IN ('IN',
                   'MT',
                   'NM',
                   'OH',
                   'OR')
     AND hd_income_band_sk BETWEEN 14 AND 20
     AND hd_buy_potential = '5001-10000'),
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
SELECT fc.c_customer_sk,
       fc.c_first_name,
       fc.c_last_name,
       count(*) AS cnt
FROM store_sales ss
JOIN store_returns sr ON ss.ss_ticket_number = sr.sr_ticket_number
AND ss.ss_item_sk = sr.sr_item_sk
JOIN web_sales ws ON ss.ss_customer_sk = ws.ws_bill_customer_sk
AND sr.sr_item_sk = ws.ws_item_sk
JOIN filtered_customers fc ON ss.ss_customer_sk = fc.c_customer_sk
JOIN filtered_item fi ON ss.ss_item_sk = fi.i_item_sk
JOIN filtered_d1 d1 ON sr.sr_returned_date_sk = d1.d_date_sk
JOIN date_dim d2 ON ws.ws_sold_date_sk = d2.d_date_sk
WHERE ss.ss_list_price > 0
  AND ss.ss_sales_price BETWEEN ss.ss_list_price * (80 * 0.01) AND ss.ss_list_price * (100 * 0.01)
  AND d2.d_date BETWEEN d1.d_date AND (d1.d_date + interval '90 day')
GROUP BY fc.c_customer_sk,
         fc.c_first_name,
         fc.c_last_name
ORDER BY cnt;