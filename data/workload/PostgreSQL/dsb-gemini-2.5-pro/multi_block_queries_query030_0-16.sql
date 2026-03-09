WITH customer_total_return AS
  (SELECT wr.wr_returning_customer_sk AS ctr_customer_sk,
          ca.ca_state AS ctr_state,
          sum(wr.wr_return_amt) AS ctr_total_return
   FROM web_returns wr
   JOIN date_dim d ON wr.wr_returned_date_sk = d.d_date_sk
   JOIN customer_address ca ON wr.wr_returning_addr_sk = ca.ca_address_sk
   JOIN item i ON wr.wr_item_sk = i.i_item_sk
   WHERE d.d_year = 2001
     AND i.i_manager_id BETWEEN 69 AND 78
     AND wr.wr_return_amt / wr.wr_return_quantity BETWEEN 28 AND 57
     AND wr.wr_reason_sk IN (3,
                             31)
   GROUP BY wr.wr_returning_customer_sk,
            ca.ca_state),
     state_avg_return AS
  (SELECT ctr_state,
          avg(ctr_total_return) AS avg_return
   FROM customer_total_return
   GROUP BY ctr_state)
SELECT c.c_customer_id,
       c.c_salutation,
       c.c_first_name,
       c.c_last_name,
       c.c_preferred_cust_flag,
       c.c_birth_day,
       c.c_birth_month,
       c.c_birth_year,
       c.c_birth_country,
       c.c_login,
       c.c_email_address,
       c.c_last_review_date_sk,
       ctr1.ctr_total_return
FROM customer c
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_total_return ctr1 ON c.c_customer_sk = ctr1.ctr_customer_sk
JOIN state_avg_return ctr2 ON ctr1.ctr_state = ctr2.ctr_state
WHERE ca.ca_state IN ('IA',
                   'MT',
                   'NE',
                   'TX')
  AND c.c_birth_year BETWEEN 1938 AND 1944
  AND ctr1.ctr_total_return > (ctr2.avg_return * 1.2)
ORDER BY c.c_customer_id,
         c.c_salutation,
         c.c_first_name,
         c.c_last_name,
         c.c_preferred_cust_flag,
         c.c_birth_day,
         c.c_birth_month,
         c.c_birth_year,
         c.c_birth_country,
         c.c_login,
         c.c_email_address,
         c.c_last_review_date_sk,
         ctr1.ctr_total_return
LIMIT 100;