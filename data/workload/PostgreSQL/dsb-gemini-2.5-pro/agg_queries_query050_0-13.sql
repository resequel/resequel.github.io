WITH all_joined AS
  (SELECT s_store_name,
          s_company_id,
          s_street_number,
          s_street_name,
          s_street_type,
          s_suite_number,
          s_city,
          s_county,
          s_state,
          s_zip,
          (d2.d_date_sk - d1.d_date_sk) AS days_diff
   FROM store_sales
   JOIN store_returns ON ss_ticket_number = sr_ticket_number
   AND ss_item_sk = sr_item_sk
   AND ss_customer_sk = sr_customer_sk
   JOIN store ON ss_store_sk = s_store_sk
   JOIN date_dim d1 ON ss_sold_date_sk = d1.d_date_sk
   JOIN date_dim d2 ON sr_returned_date_sk = d2.d_date_sk
   WHERE d2.d_year = 2000
     AND d2.d_moy = 4
     AND d1.d_date BETWEEN (d2.d_date - interval '120 day') AND d2.d_date)
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
FROM all_joined
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