WITH o AS
  (SELECT o_orderkey,
          o_custkey
   FROM orders
   WHERE o_orderdate >= date &&&_A
     AND o_orderdate < date &&&_B + interval &&&_C MONTH),
     l AS
  (SELECT l_orderkey,
          l_extendedprice * (###_A - l_discount) AS rev
   FROM lineitem
   WHERE l_returnflag = &&&_D),
     rev_agg AS
  (SELECT o.o_custkey,
          sum(l.rev) AS revenue
   FROM o
   JOIN l ON o.o_orderkey = l.l_orderkey
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