
SELECT custsale.cntrycode,
       count(*) AS numcust,
       sum(custsale.c_acctbal) AS totacctbal
FROM
  (SELECT substring(c_phone
                    FROM ###_A
                    FOR ###_B) AS cntrycode,
          c_acctbal
   FROM customer
   WHERE substring(c_phone
                   FROM ###_C
                   FOR ###_D) IN N_SSS_A
     AND c_acctbal >
       (SELECT avg(c_acctbal)
        FROM customer
        WHERE c_acctbal > ^^^_A
          AND substring(c_phone
                        FROM ###_E
                        FOR ###_F) IN N_SSS_B)
     AND NOT EXISTS
       (SELECT 1
        FROM orders
        WHERE o_custkey = c_custkey)) AS custsale
GROUP BY custsale.cntrycode
ORDER BY custsale.cntrycode;