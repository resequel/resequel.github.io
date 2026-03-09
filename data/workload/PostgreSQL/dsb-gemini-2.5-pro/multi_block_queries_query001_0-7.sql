WITH valid_customers AS
  (SELECT c_customer_sk,
          c_customer_id
   FROM customer
   JOIN customer_demographics ON c_current_cdemo_sk = cd_demo_sk
   WHERE cd_marital_status IN ('W',
                            'W')
     AND cd_education_status IN ('4 yr Degree',
                              'College')
     AND cd_gender = 'M'
     AND c_birth_month = 5
     AND c_birth_year BETWEEN 1950 AND 1956),
     customer_return_with_avg AS
  (SELECT sr_customer_sk,
          sr_store_sk,
          sr_reason_sk,
          SUM(sr_refunded_cash) AS ctr_total_return,
          AVG(SUM(sr_refunded_cash)) OVER (PARTITION BY sr_store_sk) AS avg_store_return
   FROM store_returns
   JOIN date_dim ON sr_returned_date_sk = d_date_sk
   JOIN store ON s_store_sk = sr_store_sk
   JOIN valid_customers ON sr_customer_sk = valid_customers.c_customer_sk
   WHERE d_year = 2001
     AND sr_return_amt / sr_return_quantity BETWEEN 236 AND 295
     AND s_state IN ('MI',
                  'NC',
                  'WI')
   GROUP BY sr_customer_sk,
            sr_store_sk,
            sr_reason_sk)
SELECT c_customer_id
FROM customer_return_with_avg
JOIN customer ON sr_customer_sk = c_customer_sk
WHERE ctr_total_return > avg_store_return * 1.2
  AND sr_reason_sk BETWEEN 28 AND 31
ORDER BY c_customer_id
LIMIT 100;