WITH returns_for_sales AS
  (SELECT ss.ss_sold_date_sk,
          sr.sr_returned_date_sk,
          ss.ss_store_sk,
          ss.ss_ticket_number,
          ss.ss_item_sk
   FROM store_sales ss
   JOIN store_returns sr ON ss.ss_ticket_number = sr.sr_ticket_number
   AND ss.ss_item_sk = sr.sr_item_sk
   AND ss.ss_customer_sk = sr.ss_customer_sk
   AND ss.ss_store_sk = sr.sr_store_sk)
SELECT min(s.s_store_name),
       min(s.s_company_id),
       min(s.s_street_number),
       min(s.s_street_name),
       min(s.s_suite_number),
       min(s.s_city),
       min(s.s_zip),
       min(rfs.ss_ticket_number),
       min(rfs.ss_sold_date_sk),
       min(rfs.sr_returned_date_sk),
       min(rfs.ss_item_sk),
       min(d1.d_date_sk)
FROM returns_for_sales rfs
JOIN store s ON rfs.ss_store_sk = s.s_store_sk
JOIN date_dim d1 ON rfs.ss_sold_date_sk = d1.d_date_sk
JOIN date_dim d2 ON rfs.sr_returned_date_sk = d2.d_date_sk
WHERE s.s_state IN ('GA',
                  'IL',
                  'OH')
  AND d1.d_dow = 2
  AND d2.d_moy = 8
  AND d1.d_date BETWEEN (d2.d_date - interval '120 day') AND d2.d_date;