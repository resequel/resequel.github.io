WITH d2_filtered AS
  (SELECT d_date_sk,
          d_date
   FROM date_dim
   WHERE d_year = 2000
     AND d_moy = 4),
     sr_filtered AS
  (SELECT sr.sr_ticket_number,
          sr.sr_item_sk,
          sr.sr_customer_sk,
          d2.d_date,
          sr.sr_returned_date_sk
   FROM store_returns sr
   JOIN d2_filtered d2 ON sr.sr_returned_date_sk = d2.d_date_sk),
     return_data AS
  (SELECT ss.ss_store_sk,
          (srf.sr_returned_date_sk - ss.ss_sold_date_sk) AS return_days
   FROM store_sales ss
   JOIN sr_filtered srf ON ss.ss_ticket_number = srf.sr_ticket_number
   AND ss.ss_item_sk = srf.sr_item_sk
   AND ss.ss_customer_sk = srf.sr_customer_sk
   JOIN date_dim d1 ON ss.ss_sold_date_sk = d1.d_date_sk
   WHERE d1.d_date BETWEEN (srf.d_date - interval '120 day') AND srf.d_date)
SELECT s.s_store_name,
       s.s_company_id,
       s.s_street_number,
       s.s_street_name,
       s.s_street_type,
       s.s_suite_number,
       s.s_city,
       s.s_county,
       s.s_state,
       s.s_zip,
       sum(CASE
               WHEN (rd.return_days <= 30) THEN 1
               ELSE 0
           END) AS "30 days",
       sum(CASE
               WHEN (rd.return_days > 30)
                    AND (rd.return_days <= 60) THEN 1
               ELSE 0
           END) AS "31-60 days",
       sum(CASE
               WHEN (rd.return_days > 60)
                    AND (rd.return_days <= 90) THEN 1
               ELSE 0
           END) AS "61-90 days",
       sum(CASE
               WHEN (rd.return_days > 90)
                    AND (rd.return_days <= 120) THEN 1
               ELSE 0
           END) AS "91-120 days",
       sum(CASE
               WHEN (rd.return_days > 120) THEN 1
               ELSE 0
           END) AS ">120 days"
FROM return_data rd
JOIN store s ON rd.ss_store_sk = s.s_store_sk
GROUP BY s.s_store_name,
         s.s_company_id,
         s.s_street_number,
         s.s_street_name,
         s.s_street_type,
         s.s_suite_number,
         s.s_city,
         s.s_county,
         s.s_state,
         s.s_zip
ORDER BY s_store_name,
         s_company_id,
         s_street_number,
         s_street_name,
         s_street_type,
         s_suite_number,
         s_city,
         s_county,
         s_state,
         s_zip
LIMIT 100;