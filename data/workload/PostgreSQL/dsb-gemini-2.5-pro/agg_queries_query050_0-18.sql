WITH filtered_returns AS
  (SELECT sr.sr_ticket_number,
          sr.sr_item_sk,
          sr.sr_customer_sk,
          d.d_date_sk AS returned_sk,
          d.d_date AS returned_date
   FROM store_returns sr
   JOIN date_dim d ON sr.sr_returned_date_sk = d.d_date_sk
   WHERE d.d_year = 2000
     AND d.d_moy = 4),
     sales_returns_joined AS
  (SELECT ss.ss_store_sk,
          (fr.returned_sk - ss.ss_sold_date_sk) AS days_diff
   FROM store_sales ss
   JOIN filtered_returns fr ON ss.ss_ticket_number = fr.sr_ticket_number
   AND ss.ss_item_sk = fr.sr_item_sk
   AND ss.ss_customer_sk = fr.sr_customer_sk
   JOIN date_dim d1 ON ss.ss_sold_date_sk = d1.d_date_sk
   WHERE d1.d_date BETWEEN (fr.returned_date - interval '120 day') AND fr.returned_date)
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
               WHEN (days_diff <= 30) THEN 1
               ELSE 0
           END) AS "30 days",
       sum(CASE
               WHEN (days_diff > 30
                     AND days_diff <= 60) THEN 1
               ELSE 0
           END) AS "31-60 days",
       sum(CASE
               WHEN (days_diff > 60
                     AND days_diff <= 90) THEN 1
               ELSE 0
           END) AS "61-90 days",
       sum(CASE
               WHEN (days_diff > 90
                     AND days_diff <= 120) THEN 1
               ELSE 0
           END) AS "91-120 days",
       sum(CASE
               WHEN (days_diff > 120) THEN 1
               ELSE 0
           END) AS ">120 days"
FROM sales_returns_joined
JOIN store s ON sales_returns_joined.ss_store_sk = s.s_store_sk
GROUP BY s.s_store_name,
         s.s_company_id,
         s.s_street_number,
         s.s_street_name,
         s.s_street_type,
         s.s_suite_number,
         s.s_city,
         s.s_county,
         s.s_state,
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