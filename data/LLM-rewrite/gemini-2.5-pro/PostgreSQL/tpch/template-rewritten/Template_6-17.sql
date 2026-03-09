
SELECT c.c_custkey,
       c.c_name,
       sum(l.l_extendedprice * (###_A - l.l_discount)) AS revenue,
       c.c_acctbal,
       n.n_name,
       c.c_address,
       c.c_phone,
       c.c_comment
FROM orders o
INNER JOIN lineitem l ON o.o_orderkey = l.l_orderkey
INNER JOIN customer c ON o.o_custkey = c.c_custkey
INNER JOIN nation n ON c.c_nationkey = n.n_nationkey
WHERE o.o_orderdate >= date &&&_A
  AND o.o_orderdate < date &&&_B + interval &&&_C MONTH
  AND l.l_returnflag = &&&_D
GROUP BY c.c_custkey,
         c.c_name,
         c.c_acctbal,
         c.c_phone,
         n.n_name,
         c.c_address,
         c.c_comment
ORDER BY revenue DESC
LIMIT ###_B;