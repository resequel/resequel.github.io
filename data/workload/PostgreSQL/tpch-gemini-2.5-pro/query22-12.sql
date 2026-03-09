WITH avg_bal AS
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
                                   '17')),
     valid_cust AS
  (SELECT c_custkey,
          c_acctbal,
          substring(c_phone
                    FROM 1
                    FOR 2) AS cntrycode
   FROM customer
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
     AND c_acctbal > avg_bal.threshold)
SELECT cntrycode,
       count(*) AS numcust,
       sum(c_acctbal) AS totacctbal
FROM valid_cust c
WHERE NOT EXISTS
    (SELECT 1
     FROM orders o
     WHERE o.o_custkey = c.c_custkey)
GROUP BY cntrycode
ORDER BY cntrycode;