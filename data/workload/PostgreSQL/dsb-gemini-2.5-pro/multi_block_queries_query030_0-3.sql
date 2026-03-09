WITH customer_total_return AS
  (SELECT wr_returning_customer_sk AS ctr_customer_sk,
          ca_state AS ctr_state,
          sum(wr_return_amt) AS ctr_total_return
   FROM web_returns
   JOIN date_dim ON wr_returned_date_sk = d_date_sk
   JOIN customer_address ON wr_returning_addr_sk = ca_address_sk
   JOIN item ON wr_item_sk = i_item_sk
   WHERE wr_returned_date_sk = d_date_sk
     AND d_year = 2001
     AND wr_returning_addr_sk = ca_address_sk
     AND wr_item_sk = i_item_sk
     AND i_manager_id BETWEEN 69 AND 78
     AND wr_return_amt / wr_return_quantity BETWEEN 28 AND 57
     AND wr_reason_sk IN (3,
                             31)
   GROUP BY wr_returning_customer_sk,
            ca_state)
SELECT c_customer_id,
       c_salutation,
       c_first_name,
       c_last_name,
       c_preferred_cust_flag,
       c_birth_day,
       c_birth_month,
       c_birth_year,
       c_birth_country,
       c_login,
       c_email_address,
       c_last_review_date_sk,
       ctr_total_return
FROM customer_total_return ctr1
JOIN customer_address ON ca_address_sk = c_current_addr_sk
JOIN customer ON ctr1.ctr_customer_sk = c_customer_sk
WHERE ctr1.ctr_total_return >
    (SELECT avg(ctr_total_return) * 1.2
     FROM customer_total_return ctr2
     WHERE ctr1.ctr_state = ctr2.ctr_state)
  AND ca_state IN ('IA',
                   'MT',
                   'NE',
                   'TX')
  AND c_birth_year BETWEEN 1938 AND 1944
ORDER BY c_customer_id,
         c_salutation,
         c_first_name,
         c_last_name,
         c_preferred_cust_flag,
         c_birth_day,
         c_birth_month,
         c_birth_year,
         c_birth_country,
         c_login,
         c_email_address,
         c_last_review_date_sk,
         ctr_total_return
LIMIT 100;