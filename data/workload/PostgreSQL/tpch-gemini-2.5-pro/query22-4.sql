
SELECT substring(c_phone
                 FROM 1
                 FOR 2) AS cntrycode,
       count(c_custkey) AS numcust,
       sum(c_acctbal) AS totacctbal
FROM customer c
LEFT JOIN orders o ON c.c_custkey = o.o_custkey
WHERE o.o_custkey IS NULL
  AND substring(c_phone
                FROM 1
                FOR 2) IN ('13',
                              '31',
                              '23',
                              '29',
                              '30',
                              '18',
                              '17')
  AND c_acctbal >
    (SELECT avg(c_acctbal)
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
GROUP BY substring(c_phone
                   FROM 1
                   FOR 2)
ORDER BY cntrycode;