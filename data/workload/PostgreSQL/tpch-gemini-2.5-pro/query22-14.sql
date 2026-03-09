
SELECT cntrycode,
       count(*) AS numcust,
       sum(c_acctbal) AS totacctbal
FROM
  (SELECT substring(c.c_phone
                    FROM 1
                    FOR 2) AS cntrycode,
          c.c_acctbal
   FROM customer c
   LEFT JOIN orders o ON c.c_custkey = o.o_custkey
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
   WHERE o.o_custkey IS NULL
     AND substring(c.c_phone
                   FROM 1
                   FOR 2) IN ('13',
                              '31',
                              '23',
                              '29',
                              '30',
                              '18',
                              '17')
     AND c.c_acctbal > avg_bal.threshold) AS custsale
GROUP BY cntrycode
ORDER BY cntrycode;