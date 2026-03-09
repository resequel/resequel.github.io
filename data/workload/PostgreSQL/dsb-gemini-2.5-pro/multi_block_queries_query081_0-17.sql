WITH customers_in_state AS
  (SELECT *
   FROM customer
   JOIN customer_address ON c_current_addr_sk = ca_address_sk
   WHERE ca_state = 'IL'),
     relevant_dates AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 1998),
     customer_total_return AS
  (SELECT cr_returning_customer_sk,
          ca_state,
          SUM(cr_return_amt_inc_tax) AS total_return
   FROM catalog_returns
   JOIN relevant_dates ON cr_returned_date_sk = d_date_sk
   JOIN customer_address ON cr_returning_addr_sk = ca_address_sk
   GROUP BY cr_returning_customer_sk,
            ca_state),
     state_avg AS
  (SELECT ca_state,
          AVG(total_return) AS avg_return
   FROM customer_total_return
   GROUP BY ca_state)
SELECT cust.c_customer_id,
       cust.c_salutation,
       cust.c_first_name,
       cust.c_last_name,
       cust.ca_street_number,
       cust.ca_street_name,
       cust.ca_street_type,
       cust.ca_suite_number,
       cust.ca_city,
       cust.ca_county,
       cust.ca_state,
       cust.ca_zip,
       cust.ca_country,
       cust.ca_gmt_offset,
       cust.ca_location_type,
       ctr.total_return
FROM customer_total_return ctr
JOIN state_avg sa ON ctr.ca_state = sa.ca_state
JOIN customers_in_state AS cust ON ctr.cr_returning_customer_sk = cust.c_customer_sk
WHERE ctr.total_return > (sa.avg_return * 1.2)
ORDER BY cust.c_customer_id,
         cust.c_salutation,
         cust.c_first_name,
         cust.c_last_name,
         cust.ca_street_number,
         cust.ca_street_name,
         cust.ca_street_type,
         cust.ca_suite_number,
         cust.ca_city,
         cust.ca_county,
         cust.ca_state,
         cust.ca_zip,
         cust.ca_country,
         cust.ca_gmt_offset,
         cust.ca_location_type,
         ctr.total_return
LIMIT 100;