WITH filtered_return_dates AS
  (SELECT d_date_sk,
          d_date
   FROM date_dim
   WHERE d_moy = 8),
     filtered_sale_dates AS
  (SELECT d_date_sk,
          d_date
   FROM date_dim
   WHERE d_dow = 2)
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
FROM store_sales ss
JOIN store_returns sr ON ss.ss_ticket_number = sr.sr_ticket_number
AND ss.ss_item_sk = sr.sr_item_sk
AND ss.ss_customer_sk = sr.ss_customer_sk
AND ss.ss_store_sk = sr.sr_store_sk
JOIN store s ON s.s_store_sk = ss.ss_store_sk
JOIN filtered_sale_dates d1 ON ss.ss_sold_date_sk = d1.d_date_sk
JOIN filtered_return_dates d2 ON sr.sr_returned_date_sk = d2.d_date_sk
WHERE s.s_state IN ('GA',
                  'IL',
                  'OH')
  AND d1.d_date BETWEEN (d2.d_date - interval '120 day') AND d2.d_date;