WITH filtered_returns AS
  (SELECT sr.sr_ticket_number,
          sr.sr_item_sk,
          sr.sr_customer_sk,
          sr.sr_store_sk,
          sr.sr_returned_date_sk,
          d2.d_date
   FROM store_returns sr
   JOIN date_dim d2 ON sr.sr_returned_date_sk = d2.d_date_sk
   WHERE d2.d_moy = 8),
     filtered_sales AS
  (SELECT ss.ss_ticket_number,
          ss.ss_item_sk,
          ss.ss_customer_sk,
          ss.ss_store_sk,
          ss.ss_sold_date_sk,
          d1.d_date,
          d1.d_date_sk
   FROM store_sales ss
   JOIN date_dim d1 ON ss.ss_sold_date_sk = d1.d_date_sk
   WHERE d1.d_dow = 2)
SELECT min(s.s_store_name),
       min(s.s_company_id),
       min(s.s_street_number),
       min(s.s_street_name),
       min(s.s_suite_number),
       min(s.s_city),
       min(s.s_zip),
       min(fs.ss_ticket_number),
       min(fs.ss_sold_date_sk),
       min(fr.sr_returned_date_sk),
       min(fs.ss_item_sk),
       min(fs.d_date_sk)
FROM filtered_sales fs
JOIN filtered_returns fr ON fs.ss_ticket_number = fr.sr_ticket_number
AND fs.ss_item_sk = fr.sr_item_sk
AND fs.ss_customer_sk = fr.sr_customer_sk
AND fs.ss_store_sk = fr.sr_store_sk
JOIN store s ON fs.ss_store_sk = s.s_store_sk
WHERE s.s_state IN ('GA',
                  'IL',
                  'OH')
  AND fs.d_date BETWEEN (fr.d_date - interval '120 day') AND fr.d_date;