
SELECT substring(c.c_phone
                 FROM ###_A
                 FOR ###_B) AS cntrycode,
       count(c.c_custkey) AS numcust,
       sum(c.c_acctbal) AS totacctbal
FROM customer c
WHERE substring(c.c_phone
                FROM ###_C
                FOR ###_D) IN N_SSS_A
  AND c.c_acctbal >
    (SELECT avg(c2.c_acctbal)
     FROM customer c2
     WHERE c2.c_acctbal > ^^^_A
       AND substring(c2.c_phone
                     FROM ###_E
                     FOR ###_F) IN N_SSS_B)
  AND NOT EXISTS
    (SELECT o.o_orderkey
     FROM orders o
     WHERE o.o_custkey = c.c_custkey)
GROUP BY substring(c.c_phone
                   FROM ###_A
                   FOR ###_B)
ORDER BY cntrycode;