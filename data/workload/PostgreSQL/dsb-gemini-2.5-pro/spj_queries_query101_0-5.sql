WITH filtered_ss AS
  (SELECT ss_ticket_number,
          ss_item_sk,
          ss_customer_sk
   FROM store_sales
   WHERE ss_list_price > 0
     AND ss_sales_price BETWEEN (ss_list_price * 80 * 0.01) AND (ss_list_price * 100 * 0.01))
SELECT min(c.c_customer_sk),
       min(ss.ss_item_sk),
       min(sr.sr_ticket_number),
       min(ws.ws_order_number)
FROM filtered_ss AS ss
JOIN item AS i ON ss.ss_item_sk = i.i_item_sk
JOIN customer AS c ON ss.ss_customer_sk = c.c_customer_sk
JOIN customer_address AS ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN household_demographics AS hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
JOIN store_returns AS sr ON ss.ss_ticket_number = sr.sr_ticket_number
AND ss.ss_item_sk = i.i_item_sk
JOIN date_dim AS d1 ON sr.sr_returned_date_sk = d1.d_date_sk
JOIN web_sales AS ws ON ss.ss_customer_sk = c.c_customer_sk
AND ss.ss_item_sk = i.i_item_sk
JOIN date_dim AS d2 ON ws.ws_sold_date_sk = d2.d_date_sk
WHERE i.i_category IN ('Books',
                     'Shoes',
                     'Sports')
  AND ca.ca_state IN ('IN',
                   'MT',
                   'NM',
                   'OH',
                   'OR')
  AND d1.d_year = 1999
  AND hd.hd_income_band_sk BETWEEN 14 AND 20
  AND hd.hd_buy_potential = '5001-10000'
  AND d2.d_date BETWEEN d1.d_date AND (d1.d_date + interval '90 day');