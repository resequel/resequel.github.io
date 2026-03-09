WITH avg_bal AS MATERIALIZED
  (SELECT avg(c_acctbal) AS threshold
   FROM customer
   WHERE c_acctbal > 0.00
     AND substring(c_phone
                   FROM 1
                   FOR 2) IN ('13',
                                   '31',
                                   '23',
                                   '29',
                                   '30',
                                   '18',
                                   '17'))
SELECT substring(c_phone
                 FROM 1
                 FOR 2) AS cntrycode,
       count(*) AS numcust,
       sum(c_acctbal) AS totacctbal
FROM customer c
CROSS JOIN avg_bal
WHERE substring(c_phone
                FROM 1
                FOR 2) IN ('13',
                              '31',
                              '23',
                              '29',
                              '30',
                              '18',
                              '17')
  AND c.c_acctbal > avg_bal.threshold
  AND NOT EXISTS
    (SELECT 1
     FROM orders o
     WHERE o.o_custkey = c.c_custkey)
GROUP BY substring(c_phone
                   FROM 1
                   FOR 2)
ORDER BY cntrycode;