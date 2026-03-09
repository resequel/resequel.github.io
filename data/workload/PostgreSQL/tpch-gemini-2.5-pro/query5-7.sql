
SELECT n.n_name,
       sum(l.l_extendedprice * (1 - l.l_discount)) AS revenue
FROM region r
INNER JOIN nation n ON r.r_regionkey = n.n_regionkey
INNER JOIN customer c ON n.n_nationkey = c.c_nationkey
INNER JOIN supplier s ON n.n_nationkey = s.s_nationkey
INNER JOIN
  (SELECT o_orderkey,
          o_custkey
   FROM orders
   WHERE o_orderdate >= date '1994-01-01'
     AND o_orderdate < date '1994-01-01' + interval '1' YEAR) o ON c.c_custkey = o.o_custkey
INNER JOIN lineitem l ON o.o_orderkey = l.l_orderkey
AND s.s_suppkey = l.l_suppkey
WHERE r.r_name = 'ASIA'
GROUP BY n.n_name
ORDER BY revenue DESC;