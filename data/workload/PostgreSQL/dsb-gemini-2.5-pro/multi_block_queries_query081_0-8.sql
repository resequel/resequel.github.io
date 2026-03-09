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
     customers_in_state AS
  (SELECT *
   FROM customer
   JOIN customer_address ON c_current_addr_sk = ca_address_sk
   WHERE ca_state = 'IL')
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
FROM
  (SELECT cr_returning_customer_sk,
          total_return,
          AVG(total_return) OVER (PARTITION BY ca_state) AS avg_state_return
   FROM customer_total_return) AS ctr
JOIN customers_in_state AS cust ON ctr.cr_returning_customer_sk = cust.c_customer_sk
WHERE ctr.total_return > (ctr.avg_state_return * 1.2)
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