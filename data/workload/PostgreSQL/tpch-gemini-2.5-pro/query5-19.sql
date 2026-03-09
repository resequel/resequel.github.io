
SELECT n.n_name,
       sum(l.l_extendedprice * (1 - l.l_discount)) AS revenue
FROM
  (SELECT n_nationkey,
          n_name
   FROM nation
   JOIN region ON n_regionkey = r_regionkey
   WHERE r_name = 'ASIA') n
JOIN customer c ON c.c_nationkey = n.n_nationkey
JOIN
  (SELECT o_orderkey,
          o_custkey
   FROM orders
   WHERE o_orderdate >= date '1994-01-01'
     AND o_orderdate < date '1994-01-01' + interval '1' YEAR) o ON c.c_custkey = o.o_custkey
JOIN lineitem l ON l.l_orderkey = o.o_orderkey
JOIN supplier s ON s.s_suppkey = l.l_suppkey
AND s.s_nationkey = n.n_nationkey
GROUP BY n.n_name
ORDER BY revenue DESC;