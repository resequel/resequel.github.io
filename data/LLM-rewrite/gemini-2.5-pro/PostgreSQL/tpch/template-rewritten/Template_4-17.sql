
SELECT l.l_orderkey,
       sum(l.l_extendedprice * (###_A - l.l_discount)) AS revenue,
       o.o_orderdate,
       o.o_shippriority
FROM orders o
INNER JOIN customer c ON o.o_custkey = c.c_custkey
INNER JOIN lineitem l ON o.o_orderkey = l.l_orderkey
WHERE c.c_mktsegment = &&&_A
  AND o.o_orderdate < date &&&_B
  AND l.l_shipdate > date &&&_C
GROUP BY l.l_orderkey,
         o.o_orderdate,
         o.o_shippriority
ORDER BY revenue DESC,
         o.o_orderdate
LIMIT ###_B;