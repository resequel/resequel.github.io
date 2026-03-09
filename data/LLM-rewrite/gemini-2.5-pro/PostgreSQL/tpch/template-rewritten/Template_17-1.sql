WITH avg_bal AS
  (SELECT avg(c_acctbal) AS threshold
   FROM customer
   WHERE c_acctbal > ^^^_A
     AND substring(c_phone
                   FROM ###_E
                   FOR ###_F) IN N_SSS_B)
SELECT substring(c_phone
                 FROM ###_A
                 FOR ###_B) AS cntrycode,
       count(c_custkey) AS numcust,
       sum(c_acctbal) AS totacctbal
FROM customer c
LEFT JOIN orders o ON c.c_custkey = o.o_custkey
CROSS JOIN avg_bal
WHERE o.o_custkey IS NULL
  AND substring(c_phone
                FROM ###_C
                FOR ###_D) IN N_SSS_A
  AND c.c_acctbal > avg_bal.threshold
GROUP BY substring(c_phone
                   FROM ###_A
                   FOR ###_B)
ORDER BY cntrycode;