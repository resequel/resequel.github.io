WITH avg_bal AS
  (SELECT avg(c_acctbal) AS threshold
   FROM customer
   WHERE c_acctbal > ^^^_A
     AND substring(c_phone
                   FROM ###_E
                   FOR ###_F) IN N_SSS_B),
     valid_cust AS
  (SELECT c_custkey,
          c_acctbal,
          substring(c_phone
                    FROM ###_A
                    FOR ###_B) AS cntrycode
   FROM customer
   CROSS JOIN avg_bal
   WHERE substring(c_phone
                   FROM ###_C
                   FOR ###_D) IN N_SSS_A
     AND c_acctbal > avg_bal.threshold)
SELECT cntrycode,
       count(*) AS numcust,
       sum(c_acctbal) AS totacctbal
FROM valid_cust c
WHERE NOT EXISTS
    (SELECT 1
     FROM orders o
     WHERE o.o_custkey = c.c_custkey)
GROUP BY cntrycode
ORDER BY cntrycode;