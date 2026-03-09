
SELECT min(s.s_store_name),
       min(s.s_company_id),
       min(s.s_street_number),
       min(s.s_street_name),
       min(s.s_suite_number),
       min(s.s_city),
       min(s.s_zip),
       min(sales_match.ss_ticket_number),
       min(sales_match.ss_sold_date_sk),
       min(sr.sr_returned_date_sk),
       min(sales_match.ss_item_sk),
       min(sales_match.d_date_sk)
FROM store_returns sr
JOIN date_dim d2 ON sr.sr_returned_date_sk = d2.d_date_sk
JOIN store s ON sr.sr_store_sk = s.s_store_sk
JOIN LATERAL
  (SELECT ss.ss_ticket_number,
          ss.ss_item_sk,
          ss.ss_sold_date_sk,
          d1.d_date_sk
   FROM store_sales ss
   JOIN date_dim d1 ON ss.ss_sold_date_sk = d1.d_date_sk
   WHERE ss.ss_ticket_number = sr.sr_ticket_number
     AND ss.ss_item_sk = sr.sr_item_sk
     AND ss.ss_customer_sk = sr.sr_customer_sk
     AND ss.ss_store_sk = sr.sr_store_sk
     AND d1.d_dow = 2
     AND d1.d_date BETWEEN (d2.d_date - interval '120 day') AND d2.d_date) AS sales_match ON TRUE
WHERE d2.d_moy = 8
  AND s.s_state IN ('GA',
                  'IL',
                  'OH');