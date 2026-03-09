WITH l_agg AS
  (SELECT l_orderkey,
          sum(l_extendedprice * (###_A - l_discount)) AS rev
   FROM lineitem
   WHERE l_returnflag = &&&_D
   GROUP BY l_orderkey)
SELECT c.c_custkey,
       c.c_name,
       sum(l.rev) AS revenue,
       c.c_acctbal,
       n.n_name,
       c.c_address,
       c.c_phone,
       c.c_comment
FROM customer c
JOIN orders o ON c.c_custkey = o.o_custkey
JOIN l_agg l ON o.o_orderkey = l.l_orderkey
JOIN nation n ON c.c_nationkey = n.n_nationkey
WHERE o.o_orderdate >= date &&&_A
  AND o.o_orderdate < date &&&_B + interval &&&_C MONTH
GROUP BY c.c_custkey,
         c.c_name,
         c.c_acctbal,
         c.c_phone,
         n.n_name,
         c.c_address,
         c.c_comment
ORDER BY revenue DESC
LIMIT ###_B;