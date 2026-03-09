WITH filtered_returns AS
  (SELECT sr_returned_date_sk,
          sr_ticket_number,
          sr_item_sk,
          sr_customer_sk,
          d2.d_date
   FROM store_returns
   JOIN date_dim d2 ON sr_returned_date_sk = d2.d_date_sk
   WHERE d2.d_year = 2000
     AND d2.d_moy = 4)
SELECT s_store_name,
       s_company_id,
       s_street_number,
       s_street_name,
       s_street_type,
       s_suite_number,
       s_city,
       s_county,
       s_state,
       s_zip,
       sum(CASE
               WHEN (fr.sr_returned_date_sk - ss.ss_sold_date_sk <= 30) THEN 1
               ELSE 0
           END) AS "30 days",
       sum(CASE
               WHEN (fr.sr_returned_date_sk - ss.ss_sold_date_sk > 30)
                    AND (fr.sr_returned_date_sk - ss.ss_sold_date_sk <= 60) THEN 1
               ELSE 0
           END) AS "31-60 days",
       sum(CASE
               WHEN (fr.sr_returned_date_sk - ss.ss_sold_date_sk > 60)
                    AND (fr.sr_returned_date_sk - ss.ss_sold_date_sk <= 90) THEN 1
               ELSE 0
           END) AS "61-90 days",
       sum(CASE
               WHEN (fr.sr_returned_date_sk - ss.ss_sold_date_sk > 90)
                    AND (fr.sr_returned_date_sk - ss.ss_sold_date_sk <= 120) THEN 1
               ELSE 0
           END) AS "91-120 days",
       sum(CASE
               WHEN (fr.sr_returned_date_sk - ss.ss_sold_date_sk > 120) THEN 1
               ELSE 0
           END) AS ">120 days"
FROM store_sales ss
JOIN filtered_returns fr ON ss.ss_ticket_number = fr.sr_ticket_number
AND ss.ss_item_sk = fr.sr_item_sk
AND ss.ss_customer_sk = fr.sr_customer_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN date_dim d1 ON ss.ss_sold_date_sk = d1.d_date_sk
WHERE d1.d_date BETWEEN (fr.d_date - interval '120 day') AND fr.d_date
GROUP BY s_store_name,
         s_company_id,
         s_street_number,
         s_street_name,
         s_street_type,
         s_suite_number,
         s_city,
         s_county,
         s_state,
         s_zip
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