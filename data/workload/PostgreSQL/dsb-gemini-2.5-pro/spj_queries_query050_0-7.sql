WITH returns_with_date AS
  (SELECT sr.sr_ticket_number,
          sr.sr_item_sk,
          sr.sr_customer_sk,
          sr.sr_store_sk,
          sr.sr_returned_date_sk,
          d2.d_date
   FROM store_returns sr
   JOIN date_dim d2 ON sr.sr_returned_date_sk = d2.d_date_sk
   WHERE d2.d_moy = 8)
SELECT min(s.s_store_name),
       min(s.s_company_id),
       min(s.s_street_number),
       min(s.s_street_name),
       min(s.s_suite_number),
       min(s.s_city),
       min(s.s_zip),
       min(ss.ss_ticket_number),
       min(ss.ss_sold_date_sk),
       min(rwd.sr_returned_date_sk),
       min(ss.ss_item_sk),
       min(d1.d_date_sk)
FROM store_sales ss
JOIN returns_with_date rwd ON ss.ss_ticket_number = rwd.sr_ticket_number
AND ss.ss_item_sk = rwd.sr_item_sk
AND ss.ss_customer_sk = rwd.sr_customer_sk
AND ss.ss_store_sk = rwd.sr_store_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN date_dim d1 ON ss.ss_sold_date_sk = d1.d_date_sk
WHERE s.s_state IN ('GA',
                  'IL',
                  'OH')
  AND d1.d_dow = 2
  AND d1.d_date BETWEEN (rwd.d_date - interval '120 day') AND rwd.d_date;