
SELECT c.c_custkey,
       c.c_name,
       sum(l.rev) AS revenue,
       c.c_acctbal,
       n.n_name,
       c.c_address,
       c.c_phone,
       c.c_comment
FROM customer c
JOIN
  (SELECT o_orderkey,
          o_custkey
   FROM orders
   WHERE o_orderdate >= date &&&_A
     AND o_orderdate < date &&&_B + interval &&&_C MONTH) o ON c.c_custkey = o.o_custkey
JOIN
  (SELECT l_orderkey,
          l_extendedprice * (###_A - l_discount) AS rev
   FROM lineitem
   WHERE l_returnflag = &&&_D) l ON o.o_orderkey = l.l_orderkey
JOIN nation n ON c.c_nationkey = n.n_nationkey
GROUP BY c.c_custkey,
         c.c_name,
         c.c_acctbal,
         c.c_phone,
         n.n_name,
         c.c_address,
         c.c_comment
ORDER BY revenue DESC
LIMIT ###_B;