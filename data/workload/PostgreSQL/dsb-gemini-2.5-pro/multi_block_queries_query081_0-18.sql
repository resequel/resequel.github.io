WITH state_avg_return AS
  (SELECT ctr_state,
          AVG(ctr_total_return) AS avg_return
   FROM
     (SELECT ca.ca_state AS ctr_state,
             SUM(cr.cr_return_amt_inc_tax) AS ctr_total_return
      FROM catalog_returns AS cr
      JOIN date_dim AS d ON cr.cr_returned_date_sk = d.d_date_sk
      JOIN customer_address AS ca ON cr.cr_returning_addr_sk = ca.ca_address_sk
      WHERE d.d_year = 1998
      GROUP BY cr.cr_returning_customer_sk,
               ca.ca_state) AS customer_returns
   GROUP BY ctr_state)
SELECT c.c_customer_id,
       c.c_salutation,
       c.c_first_name,
       c.c_last_name,
       ca.ca_street_number,
       ca.ca_street_name,
       ca.ca_street_type,
       ca.ca_suite_number,
       ca.ca_city,
       ca.ca_county,
       ca.ca_state,
       ca.ca_zip,
       ca.ca_country,
       ca.ca_gmt_offset,
       ca.ca_location_type,
       SUM(cr.cr_return_amt_inc_tax) AS ctr_total_return
FROM customer AS c
JOIN customer_address AS ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN catalog_returns AS cr ON c.c_customer_sk = cr.cr_returning_customer_sk
JOIN date_dim AS d ON cr.cr_returned_date_sk = d.d_date_sk
JOIN customer_address AS ca_return ON cr.cr_returning_addr_sk = ca_return.ca_address_sk
JOIN state_avg_return AS sar ON ca_return.ca_state = sar.ctr_state
WHERE ca.ca_state = 'IL'
  AND d.d_year = 1998
GROUP BY c.c_customer_id,
         c.c_salutation,
         c.c_first_name,
         c.c_last_name,
         ca.ca_street_number,
         ca.ca_street_name,
         ca.ca_street_type,
         ca.ca_suite_number,
         ca.ca_city,
         ca.ca_county,
         ca.ca_state,
         ca.ca_zip,
         ca.ca_country,
         ca.ca_gmt_offset,
         ca.ca_location_type,
         sar.avg_return,
         ca_return.ca_state
HAVING SUM(cr.cr_return_amt_inc_tax) > sar.avg_return * 1.2
ORDER BY c.c_customer_id,
         c.c_salutation,
         c.c_first_name,
         c.c_last_name,
         ca.ca_street_number,
         ca.ca_street_name,
         ca.ca_street_type,
         ca.ca_suite_number,
         ca.ca_city,
         ca.ca_county,
         ca.ca_state,
         ca.ca_zip,
         ca.ca_country,
         ca.ca_gmt_offset,
         ca.ca_location_type,
         ctr_total_return
LIMIT 100;