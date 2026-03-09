
SELECT cntrycode,
       count(*) AS numcust,
       sum(c_acctbal) AS totacctbal
FROM
  (SELECT substring(customer.c_phone
                    FROM 1
                    FOR 2) AS cntrycode,
          customer.c_acctbal
   FROM customer
   WHERE substring(customer.c_phone
                   FROM 1
                   FOR 2) IN ('13',
                              '31',
                              '23',
                              '29',
                              '30',
                              '18',
                              '17')
     AND customer.c_acctbal >
       (SELECT avg(customer.c_acctbal)
        FROM customer
        WHERE customer.c_acctbal > 0.00
          AND substring(customer.c_phone
                        FROM 1
                        FOR 2) IN ('13',
                                   '31',
                                   '23',
                                   '29',
                                   '30',
                                   '18',
                                   '17'))
     AND NOT EXISTS
       (SELECT *
        FROM orders
        WHERE orders.o_custkey = customer.c_custkey)) AS custsale
GROUP BY cntrycode
ORDER BY cntrycode;