
SELECT cntrycode,
       count(*) AS numcust,
       sum(c_acctbal) AS totacctbal
FROM
  (SELECT substring(c_phone
                    FROM 1
                    FOR 2) AS cntrycode,
          c_acctbal
   FROM customer c
   CROSS JOIN
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
                                   '17')) avg_bal
   WHERE substring(c_phone
                   FROM 1
                   FOR 2) IN ('13',
                              '31',
                              '23',
                              '29',
                              '30',
                              '18',
                              '17')
     AND c_acctbal > avg_bal.threshold
     AND NOT EXISTS
       (SELECT 1
        FROM orders o
        WHERE o.o_custkey = c.c_custkey)) AS custsale
GROUP BY cntrycode
ORDER BY cntrycode;