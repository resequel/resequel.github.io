
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
       returns_with_avg.total_return
FROM
  (SELECT total_return,
          cr_returning_customer_sk,
          ca_state,
          avg(total_return) OVER (PARTITION BY ca_state) AS avg_state_return
   FROM
     (SELECT cr_returning_customer_sk,
             ca_state,
             SUM(cr_return_amt_inc_tax) AS total_return
      FROM catalog_returns
      JOIN date_dim ON cr_returned_date_sk = d_date_sk
      JOIN customer_address ON cr_returning_addr_sk = ca_address_sk
      WHERE d_year = 1998
      GROUP BY cr_returning_customer_sk,
               ca_state) AS returns_by_cust_state) AS returns_with_avg
JOIN customer c ON returns_with_avg.cr_returning_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
WHERE returns_with_avg.total_return > (returns_with_avg.avg_state_return * 1.2)
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
         returns_with_avg.total_return
LIMIT 100;