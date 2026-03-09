WITH rev_agg AS MATERIALIZED
  (SELECT o.o_custkey, sum(l.l_extendedprice * (###_A - l.l_discount)) AS revenue
   FROM orders o
   JOIN lineitem l ON o.o_orderkey = l.l_orderkey
   WHERE o.o_orderdate >= date &&&_A
     AND o.o_orderdate < date &&&_B + interval &&&_C MONTH
     AND l.l_returnflag = &&&_D
   GROUP BY o.o_custkey)
SELECT c.c_custkey,
       c.c_name,
       r.revenue,
       c.c_acctbal,
       n.n_name,
       c.c_address,
       c.c_phone,
       c.c_comment
FROM rev_agg r
JOIN customer c ON r.o_custkey = c.c_custkey
JOIN nation n ON c.c_nationkey = n.n_nationkey
ORDER BY r.revenue DESC
LIMIT ###_B;