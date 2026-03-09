WITH customer_total_return AS
  (SELECT cr_returning_customer_sk,
          ca_state,
          SUM(cr_return_amt_inc_tax) AS total_return
   FROM catalog_returns
   JOIN date_dim ON cr_returned_date_sk = d_date_sk
   JOIN customer_address ON cr_returning_addr_sk = ca_address_sk
   WHERE d_year = 1998
   GROUP BY cr_returning_customer_sk,
            ca_state),
     state_avg AS
  (SELECT ca_state,
          AVG(total_return) AS avg_return
   FROM customer_total_return
   GROUP BY ca_state)
SELECT c_customer_id,
       c_salutation,
       c_first_name,
       c_last_name,
       ca_street_number,
       ca_street_name,
       ca_street_type,
       ca_suite_number,
       ca_city,
       ca_county,
       ca_state,
       ca_zip,
       ca_country,
       ca_gmt_offset,
       ca_location_type,
       ctr.total_return
FROM customer_total_return ctr
JOIN state_avg sa ON ctr.ca_state = sa.ca_state
JOIN customer c ON ctr.cr_returning_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
WHERE ctr.total_return > (sa.avg_return * 1.2)
  AND ca.ca_state = 'IL'
ORDER BY c_customer_id,
         c_salutation,
         c_first_name,
         c_last_name,
         ca_street_number,
         ca_street_name,
         ca_street_type,
         ca_suite_number,
         ca_city,
         ca_county,
         ca_state,
         ca_zip,
         ca_country,
         ca_gmt_offset,
         ca_location_type,
         ctr.total_return
LIMIT 100;