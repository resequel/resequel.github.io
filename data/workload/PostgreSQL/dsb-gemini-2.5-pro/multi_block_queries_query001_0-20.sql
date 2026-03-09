WITH customer_total_return AS
  (SELECT sr_customer_sk,
          sr_store_sk,
          sr_reason_sk,
          SUM(sr_refunded_cash) AS ctr_total_return
   FROM store_returns
   JOIN date_dim ON sr_returned_date_sk = d_date_sk
   WHERE d_year = 2001
     AND sr_return_amt / sr_return_quantity BETWEEN 236 AND 295
   GROUP BY sr_customer_sk,
            sr_store_sk,
            sr_reason_sk),
     customer_return_with_avg AS
  (SELECT ctr_customer_sk,
          ctr_store_sk,
          ctr_reason_sk,
          ctr_total_return,
          AVG(ctr_total_return) OVER (PARTITION BY ctr_store_sk) AS avg_store_return
   FROM customer_total_return)
SELECT c_customer_id
FROM customer_return_with_avg ctr
JOIN store s ON s.s_store_sk = ctr.ctr_store_sk
JOIN customer c ON c.c_customer_sk = ctr.ctr_customer_sk
JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
WHERE ctr.ctr_total_return > ctr.avg_store_return * 1.2
  AND ctr.ctr_reason_sk BETWEEN 28 AND 31
  AND s.s_state IN ('MI',
                  'NC',
                  'WI')
  AND cd.cd_marital_status IN ('W',
                            'W')
  AND cd.cd_education_status IN ('4 yr Degree',
                              'College')
  AND cd.cd_gender = 'M'
  AND c.c_birth_month = 5
  AND c.c_birth_year BETWEEN 1950 AND 1956
ORDER BY c_customer_id
LIMIT 100;