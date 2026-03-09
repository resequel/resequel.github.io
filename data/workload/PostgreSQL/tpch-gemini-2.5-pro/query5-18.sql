WITH n AS MATERIALIZED
  (SELECT n_nationkey, n_name
   FROM nation
   JOIN region ON n_regionkey = r_regionkey
   WHERE r_name = 'ASIA')
SELECT n.n_name,
       sum(l.l_extendedprice * (1 - l.l_discount)) AS revenue
FROM n
JOIN customer c ON c.c_nationkey = n.n_nationkey
JOIN orders o ON c.c_custkey = o.o_custkey
JOIN lineitem l ON l.l_orderkey = o.o_orderkey
JOIN supplier s ON s.s_suppkey = l.l_suppkey
AND s.s_nationkey = n.n_nationkey
WHERE o.o_orderdate >= date '1994-01-01'
  AND o.o_orderdate < date '1994-01-01' + interval '1' YEAR
GROUP BY n.n_name
ORDER BY revenue DESC;