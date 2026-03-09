
SELECT c.c_custkey,
       c.c_name,
       r.revenue,
       c.c_acctbal,
       n.n_name,
       c.c_address,
       c.c_phone,
       c.c_comment
FROM
  (SELECT o.o_custkey,
          sum(l.l_extendedprice * (###_A - l.l_discount)) AS revenue
   FROM
     (SELECT o_orderkey,
             o_custkey
      FROM orders
      WHERE o_orderdate >= date &&&_A
        AND o_orderdate < date &&&_B + interval &&&_C MONTH) o
   JOIN
     (SELECT l_orderkey,
             l_extendedprice,
             l_discount
      FROM lineitem
      WHERE l_returnflag = &&&_D) l ON o.o_orderkey = l.l_orderkey
   GROUP BY o.o_custkey) r
JOIN customer c ON r.o_custkey = c.c_custkey
JOIN nation n ON c.c_nationkey = n.n_nationkey
ORDER BY r.revenue DESC
LIMIT ###_B;