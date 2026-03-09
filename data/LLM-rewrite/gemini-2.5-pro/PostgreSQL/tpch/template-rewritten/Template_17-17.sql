
SELECT cntrycode,
       count(*) AS numcust,
       sum(c_acctbal) AS totacctbal
FROM
  (SELECT substring(customer.c_phone
                    FROM ###_A
                    FOR ###_B) AS cntrycode,
          customer.c_acctbal
   FROM customer
   WHERE substring(customer.c_phone
                   FROM ###_C
                   FOR ###_D) IN N_SSS_A
     AND customer.c_acctbal >
       (SELECT avg(customer.c_acctbal)
        FROM customer
        WHERE customer.c_acctbal > ^^^_A
          AND substring(customer.c_phone
                        FROM ###_E
                        FOR ###_F) IN N_SSS_B)
     AND NOT EXISTS
       (SELECT *
        FROM orders
        WHERE orders.o_custkey = customer.c_custkey)) AS custsale
GROUP BY cntrycode
ORDER BY cntrycode;