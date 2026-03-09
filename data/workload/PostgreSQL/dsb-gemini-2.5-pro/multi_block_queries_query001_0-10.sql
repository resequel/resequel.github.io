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
            sr_reason_sk)
SELECT c_customer_id
FROM customer_total_return ctr1,
     store,
     customer,
     customer_demographics,

  (SELECT ctr2.ctr_store_sk,
          AVG(ctr2.ctr_total_return) AS avg_ret
   FROM customer_total_return ctr2
   GROUP BY ctr2.ctr_store_sk) AS store_avg
WHERE ctr1.ctr_total_return > store_avg.avg_ret * 1.2
  AND s_store_sk = ctr1.ctr_store_sk
  AND ctr1.ctr_store_sk = store_avg.ctr_store_sk
  AND ctr1.ctr_customer_sk = c_customer_sk
  AND c_current_cdemo_sk = cd_demo_sk
  AND ctr1.ctr_reason_sk BETWEEN 28 AND 31
  AND s_state IN ('MI',
                  'NC',
                  'WI')
  AND cd_marital_status IN ('W',
                            'W')
  AND cd_education_status IN ('4 yr Degree',
                              'College')
  AND cd_gender = 'M'
  AND c_birth_month = 5
  AND c_birth_year BETWEEN 1950 AND 1956
ORDER BY c_customer_id
LIMIT 100;