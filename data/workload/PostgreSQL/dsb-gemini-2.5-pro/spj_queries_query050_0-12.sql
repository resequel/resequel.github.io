WITH sales_details AS
  (SELECT ss.ss_ticket_number,
          ss.ss_item_sk,
          ss.ss_customer_sk,
          ss.ss_store_sk,
          ss.ss_sold_date_sk,
          d1.d_date,
          d1.d_date_sk,
          s.s_store_name,
          s.s_company_id,
          s.s_street_number,
          s.s_street_name,
          s.s_suite_number,
          s.s_city,
          s.s_zip
   FROM store_sales ss
   JOIN date_dim d1 ON ss.ss_sold_date_sk = d1.d_date_sk
   JOIN store s ON ss.ss_store_sk = s.s_store_sk
   WHERE d1.d_dow = 2
     AND s.s_state IN ('GA',
                  'IL',
                  'OH'))
SELECT min(sd.s_store_name),
       min(sd.s_company_id),
       min(sd.s_street_number),
       min(sd.s_street_name),
       min(sd.s_suite_number),
       min(sd.s_city),
       min(sd.s_zip),
       min(sd.ss_ticket_number),
       min(sd.ss_sold_date_sk),
       min(sr.sr_returned_date_sk),
       min(sd.ss_item_sk),
       min(sd.d_date_sk)
FROM sales_details sd
JOIN store_returns sr ON sd.ss_ticket_number = sr.sr_ticket_number
AND sd.ss_item_sk = sr.sr_item_sk
AND sd.ss_customer_sk = sr.sr_customer_sk
AND sd.ss_store_sk = sr.sr_store_sk
JOIN date_dim d2 ON sr.sr_returned_date_sk = d2.d_date_sk
WHERE d2.d_moy = 8
  AND sd.d_date BETWEEN (d2.d_date - interval '120 day') AND d2.d_date;