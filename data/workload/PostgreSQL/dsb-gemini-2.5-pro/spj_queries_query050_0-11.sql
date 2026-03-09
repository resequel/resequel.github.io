
SELECT min(s.s_store_name),
       min(s.s_company_id),
       min(s.s_street_number),
       min(s.s_street_name),
       min(s.s_suite_number),
       min(s.s_city),
       min(s.s_zip),
       min(ss.ss_ticket_number),
       min(ss.ss_sold_date_sk),
       min(sr.sr_returned_date_sk),
       min(ss.ss_item_sk),
       min(d1.d_date_sk)
FROM date_dim d1
JOIN date_dim d2 ON d1.d_date BETWEEN (d2.d_date - interval '120 day') AND d2.d_date
JOIN store_sales ss ON ss.ss_sold_date_sk = d1.d_date_sk
JOIN store_returns sr ON sr.sr_returned_date_sk = d2.d_date_sk
AND ss.ss_ticket_number = sr.sr_ticket_number
AND ss.ss_item_sk = sr.sr_item_sk
AND ss.ss_customer_sk = sr.ss_customer_sk
JOIN store s ON s.s_store_sk = ss.ss_store_sk
AND s.s_store_sk = sr.sr_store_sk
WHERE d1.d_dow = 2
  AND d2.d_moy = 8
  AND s.s_state IN ('GA',
                  'IL',
                  'OH');