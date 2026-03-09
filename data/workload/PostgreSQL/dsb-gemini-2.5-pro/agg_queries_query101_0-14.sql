WITH ss_sr AS
  (SELECT ss_customer_sk,
          ss_item_sk,
          sr_returned_date_sk
   FROM store_sales
   JOIN store_returns ON ss_ticket_number = sr_ticket_number
   AND ss_item_sk = sr_item_sk
   WHERE ss_list_price > 0
     AND ss_sales_price BETWEEN ss_list_price * (80 * 0.01) AND ss_list_price * (100 * 0.01)),
     sales_triplet AS
  (SELECT ss_sr.ss_customer_sk,
          ss_sr.ss_item_sk
   FROM ss_sr
   JOIN web_sales ws ON ss_sr.ss_customer_sk = ws.ws_bill_customer_sk
   AND ss_sr.ss_item_sk = ws.ws_item_sk
   JOIN date_dim d1 ON ss_sr.sr_returned_date_sk = d1.d_date_sk
   JOIN date_dim d2 ON ws.ws_sold_date_sk = d2.d_date_sk
   WHERE d1.d_year = 1999
     AND d2.d_date BETWEEN d1.d_date AND (d1.d_date + interval '90 day'))
SELECT c.c_customer_sk,
       c.c_first_name,
       c.c_last_name,
       count(*) AS cnt
FROM sales_triplet st
JOIN customer c ON st.ss_customer_sk = c.c_customer_sk
JOIN item i ON st.ss_item_sk = i.i_item_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
WHERE ca.ca_state IN ('IN',
                   'MT',
                   'NM',
                   'OH',
                   'OR')
  AND hd.hd_income_band_sk BETWEEN 14 AND 20
  AND hd.hd_buy_potential = '5001-10000'
  AND i.i_category IN ('Books',
                     'Shoes',
                     'Sports')
GROUP BY c.c_customer_sk,
         c.c_first_name,
         c.c_last_name
ORDER BY cnt;