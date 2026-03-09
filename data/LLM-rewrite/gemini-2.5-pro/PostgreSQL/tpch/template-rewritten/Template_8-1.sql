WITH n AS
  (SELECT n_nationkey,
          n_name
   FROM nation
   JOIN region ON n_regionkey = r_regionkey
   WHERE r_name = &&&_A),
     o AS
  (SELECT o_orderkey,
          o_custkey
   FROM orders
   WHERE o_orderdate >= date &&&_B
     AND o_orderdate < date &&&_C + interval &&&_D YEAR)
SELECT n.n_name,
       sum(l.l_extendedprice * (###_A - l.l_discount)) AS revenue
FROM n
JOIN customer c ON c.c_nationkey = n.n_nationkey
JOIN o ON c.c_custkey = o.o_custkey
JOIN lineitem l ON l.l_orderkey = o.o_orderkey
JOIN supplier s ON s.s_suppkey = l.l_suppkey
AND s.s_nationkey = n.n_nationkey
GROUP BY n.n_name
ORDER BY revenue DESC;