
SELECT substring(c.c_phone
                 FROM 1
                 FOR 2) AS cntrycode,
       count(c.c_custkey) AS numcust,
       sum(c.c_acctbal) AS totacctbal
FROM customer c
WHERE substring(c.c_phone
                FROM 1
                FOR 2) IN ('13',
                              '31',
                              '23',
                              '29',
                              '30',
                              '18',
                              '17')
  AND c.c_acctbal >
    (SELECT avg(c2.c_acctbal)
     FROM customer c2
     WHERE c2.c_acctbal > 0.00
       AND substring(c2.c_phone
                     FROM 1
                     FOR 2) IN ('13',
                                   '31',
                                   '23',
                                   '29',
                                   '30',
                                   '18',
                                   '17'))
  AND NOT EXISTS
    (SELECT o.o_orderkey
     FROM orders o
     WHERE o.o_custkey = c.c_custkey)
GROUP BY substring(c.c_phone
                   FROM 1
                   FOR 2)
ORDER BY cntrycode;