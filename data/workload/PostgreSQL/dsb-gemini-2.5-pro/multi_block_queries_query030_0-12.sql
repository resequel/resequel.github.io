WITH qualified_customers AS
  (SELECT c.c_customer_sk
   FROM customer c
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   WHERE ca.ca_state IN ('IA',
                   'MT',
                   'NE',
                   'TX')
     AND c.c_birth_year BETWEEN 1938 AND 1944),
     customer_total_return AS
  (SELECT wr.wr_returning_customer_sk AS ctr_customer_sk,
          ca.ca_state AS ctr_state,
          sum(wr.wr_return_amt) AS ctr_total_return
   FROM web_returns wr
   JOIN date_dim d ON wr.wr_returned_date_sk = d.d_date_sk
   JOIN item i ON wr.wr_item_sk = i.i_item_sk
   JOIN customer_address ca ON wr.wr_returning_addr_sk = ca.ca_address_sk
   WHERE d.d_year = 2001
     AND i.i_manager_id BETWEEN 69 AND 78
     AND wr.wr_return_amt / wr.wr_return_quantity BETWEEN 28 AND 57
     AND wr.wr_reason_sk IN (3,
                             31)
   GROUP BY wr.wr_returning_customer_sk,
            ca.ca_state),
     returns_with_avg AS
  (SELECT ctr_customer_sk,
          ctr_state,
          ctr_total_return,
          avg(ctr_total_return) OVER (PARTITION BY ctr_state) AS avg_return
   FROM customer_total_return)
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
       r.ctr_total_return
FROM returns_with_avg r
JOIN customer c ON r.ctr_customer_sk = c.c_customer_sk
JOIN qualified_customers qc ON c.c_customer_sk = qc.c_customer_sk
WHERE r.ctr_total_return > (r.avg_return * 1.2)
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
         r.ctr_total_return
LIMIT 100;