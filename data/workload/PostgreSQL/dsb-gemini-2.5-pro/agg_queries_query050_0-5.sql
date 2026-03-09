WITH returns_in_month AS
  (SELECT sr.sr_ticket_number,
          sr.sr_item_sk,
          sr.sr_customer_sk,
          d.d_date,
          sr.sr_returned_date_sk
   FROM date_dim d
   JOIN store_returns sr ON d.d_date_sk = sr.sr_returned_date_sk
   WHERE d.d_year = 2000
     AND d.d_moy = 4),
     sales_for_returns AS
  (SELECT ss.ss_store_sk,
          (rim.sr_returned_date_sk - ss.ss_sold_date_sk) AS return_days
   FROM store_sales ss
   JOIN returns_in_month rim ON ss.ss_ticket_number = rim.sr_ticket_number
   AND ss.ss_item_sk = rim.sr_item_sk
   AND ss.ss_customer_sk = rim.sr_customer_sk
   JOIN date_dim d1 ON ss.ss_sold_date_sk = d1.d_date_sk
   WHERE d1.d_date BETWEEN (rim.d_date - interval '120 day') AND rim.d_date),
     store_level_agg AS
  (SELECT sfr.ss_store_sk,
          sum(CASE
                  WHEN (sfr.return_days <= 30) THEN 1
                  ELSE 0
              END) AS days_30,
          sum(CASE
                  WHEN (sfr.return_days > 30)
                       AND (sfr.return_days <= 60) THEN 1
                  ELSE 0
              END) AS days_60,
          sum(CASE
                  WHEN (sfr.return_days > 60)
                       AND (sfr.return_days <= 90) THEN 1
                  ELSE 0
              END) AS days_90,
          sum(CASE
                  WHEN (sfr.return_days > 90)
                       AND (sfr.return_days <= 120) THEN 1
                  ELSE 0
              END) AS days_120,
          sum(CASE
                  WHEN (sfr.return_days > 120) THEN 1
                  ELSE 0
              END) AS days_over_120
   FROM sales_for_returns sfr
   GROUP BY sfr.ss_store_sk)
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
       sla.days_30 AS "30 days",
       sla.days_60 AS "31-60 days",
       sla.days_90 AS "61-90 days",
       sla.days_120 AS "91-120 days",
       sla.days_over_120 AS ">120 days"
FROM store_level_agg sla
JOIN store s ON sla.ss_store_sk = s.s_store_sk
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