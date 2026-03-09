
SELECT cntrycode,
       count(numcust) AS numcust,
       sum(c_acctbal) AS totacctbal
FROM
  (SELECT substring(c_phone
                    FROM 1
                    FOR 2) AS cntrycode,
          c_acctbal,
          c_custkey AS numcust
   FROM customer
   WHERE substring(c_phone
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
     AND NOT EXISTS
       (SELECT 1
        FROM orders
        WHERE o_custkey = c_custkey)) AS custsale
GROUP BY cntrycode
ORDER BY cntrycode;