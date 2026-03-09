
SELECT n_name,
       sum(rev) AS revenue
FROM
  (SELECT n.n_name,
          l.l_extendedprice * (1 - l.l_discount) AS rev
   FROM region r
   JOIN nation n ON r.r_regionkey = n.n_regionkey
   JOIN supplier s ON n.n_nationkey = s.s_nationkey
   JOIN customer c ON n.n_nationkey = c.c_nationkey
   JOIN orders o ON c.c_custkey = o.o_custkey
   JOIN lineitem l ON o.o_orderkey = l.l_orderkey
   AND s.s_suppkey = l.l_suppkey
   WHERE r.r_name = 'ASIA'
     AND o.o_orderdate >= date '1994-01-01'
     AND o.o_orderdate < date '1994-01-01' + interval '1' YEAR) calc
GROUP BY n_name
ORDER BY revenue DESC;