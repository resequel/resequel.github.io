WITH date_filtered AS
  (SELECT d_date_sk,
          d_date
   FROM date_dim
   WHERE d_year = 2000
     AND d_moy = 4),
     store_agg AS
  (SELECT ss.ss_store_sk,
          sum(CASE
                  WHEN ((d2.d_date_sk - d1.d_date_sk) <= 30) THEN 1
                  ELSE 0
              END) AS c1,
          sum(CASE
                  WHEN ((d2.d_date_sk - d1.d_date_sk) > 30
                        AND (d2.d_date_sk - d1.d_date_sk) <= 60) THEN 1
                  ELSE 0
              END) AS c2,
          sum(CASE
                  WHEN ((d2.d_date_sk - d1.d_date_sk) > 60
                        AND (d2.d_date_sk - d1.d_date_sk) <= 90) THEN 1
                  ELSE 0
              END) AS c3,
          sum(CASE
                  WHEN ((d2.d_date_sk - d1.d_date_sk) > 90
                        AND (d2.d_date_sk - d1.d_date_sk) <= 120) THEN 1
                  ELSE 0
              END) AS c4,
          sum(CASE
                  WHEN ((d2.d_date_sk - d1.d_date_sk) > 120) THEN 1
                  ELSE 0
              END) AS c5
   FROM store_sales ss
   JOIN store_returns sr ON ss.ss_ticket_number = sr.sr_ticket_number
   AND ss.ss_item_sk = sr.sr_item_sk
   AND ss.ss_customer_sk = sr.sr_customer_sk
   JOIN date_filtered d2 ON sr.sr_returned_date_sk = d2.d_date_sk
   JOIN date_dim d1 ON ss.ss_sold_date_sk = d1.d_date_sk
   WHERE d1.d_date BETWEEN (d2.d_date - interval '120 day') AND d2.d_date
   GROUP BY ss.ss_store_sk)
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
       c1 AS "30 days",
       c2 AS "31-60 days",
       c3 AS "61-90 days",
       c4 AS "91-120 days",
       c5 AS ">120 days"
FROM store_agg
JOIN store s ON store_agg.ss_store_sk = s.s_store_sk
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