
SELECT l.l_orderkey,
       sum(l.l_extendedprice * (1 - l.l_discount)) AS revenue,
       o.o_orderdate,
       o.o_shippriority
FROM orders o
INNER JOIN customer c ON o.o_custkey = c.c_custkey
INNER JOIN lineitem l ON o.o_orderkey = l.l_orderkey
WHERE c.c_mktsegment = 'BUILDING'
  AND o.o_orderdate < date '1995-03-15'
  AND l.l_shipdate > date '1995-03-15'
GROUP BY l.l_orderkey,
         o.o_orderdate,
         o.o_shippriority
ORDER BY revenue DESC,
         o.o_orderdate
LIMIT 10;