
SELECT c_custkey,
       c_name,
       sum(l_extendedprice * (###_A - l_discount)) AS revenue,
       c_acctbal,
       n_name,
       c_address,
       c_phone,
       c_comment
FROM nation n
JOIN customer c ON n.n_nationkey = c.c_nationkey
JOIN orders o ON c.c_custkey = o.o_custkey
JOIN lineitem l ON o.o_orderkey = l.l_orderkey
WHERE o.o_orderdate >= date &&&_A
  AND o.o_orderdate < date &&&_B + interval &&&_C MONTH
  AND l.l_returnflag = &&&_D
GROUP BY c_custkey,
         c_name,
         c_acctbal,
         c_phone,
         n_name,
         c_address,
         c_comment
ORDER BY revenue DESC
LIMIT ###_B;