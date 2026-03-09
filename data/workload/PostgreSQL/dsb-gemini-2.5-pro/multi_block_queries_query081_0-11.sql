WITH customer_state_returns AS
  (SELECT ctr_customer_sk,
          ctr_state,
          ctr_total_return,
          AVG(ctr_total_return) OVER (PARTITION BY ctr_state) AS avg_state_return
   FROM
     (SELECT cr.cr_returning_customer_sk AS ctr_customer_sk,
             ca.ca_state AS ctr_state,
             SUM(cr.cr_return_amt_inc_tax) AS ctr_total_return
      FROM catalog_returns AS cr
      JOIN date_dim AS d ON cr.cr_returned_date_sk = d.d_date_sk
      JOIN customer_address AS ca ON cr.cr_returning_addr_sk = ca.ca_address_sk
      WHERE d.d_year = 1998
      GROUP BY cr.cr_returning_customer_sk,
               ca.ca_state) AS customer_total_return),
     filtered_customers AS
  (SELECT c.c_customer_sk,
          c.c_customer_id,
          c.c_salutation,
          c.c_first_name,
          c.c_last_name,
          ca.*
   FROM customer AS c
   JOIN customer_address AS ca ON c.c_current_addr_sk = ca.ca_address_sk
   WHERE ca.ca_state = 'IL')
SELECT fc.c_customer_id,
       fc.c_salutation,
       fc.c_first_name,
       fc.c_last_name,
       fc.ca_street_number,
       fc.ca_street_name,
       fc.ca_street_type,
       fc.ca_suite_number,
       fc.ca_city,
       fc.ca_county,
       fc.ca_state,
       fc.ca_zip,
       fc.ca_country,
       fc.ca_gmt_offset,
       fc.ca_location_type,
       csr.ctr_total_return
FROM customer_state_returns AS csr
JOIN filtered_customers AS fc ON csr.ctr_customer_sk = fc.c_customer_sk
WHERE csr.ctr_total_return > csr.avg_state_return * 1.2
ORDER BY fc.c_customer_id,
         fc.c_salutation,
         fc.c_first_name,
         fc.c_last_name,
         fc.ca_street_number,
         fc.ca_street_name,
         fc.ca_street_type,
         fc.ca_suite_number,
         fc.ca_city,
         fc.ca_county,
         fc.ca_state,
         fc.ca_zip,
         fc.ca_country,
         fc.ca_gmt_offset,
         fc.ca_location_type,
         csr.ctr_total_return
LIMIT 100;