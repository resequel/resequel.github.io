
SELECT n.n_name,
       sum(l.l_extendedprice * (1 - l.l_discount)) AS revenue
FROM orders o
INNER JOIN customer c ON o.o_custkey = c.c_custkey
INNER JOIN nation n ON c.c_nationkey = n.n_nationkey
INNER JOIN region r ON n.n_regionkey = r.r_regionkey
INNER JOIN supplier s ON n.n_nationkey = s.s_nationkey
INNER JOIN lineitem l ON o.o_orderkey = l.l_orderkey
AND s.s_suppkey = l.l_suppkey
WHERE r.r_name = 'ASIA'
  AND o.o_orderdate >= date '1994-01-01'
  AND o.o_orderdate < date '1994-01-01' + interval '1' YEAR
GROUP BY n.n_name
ORDER BY revenue DESC;