
SELECT l.l_orderkey,
       sum(l.l_extendedprice * (###_A - l.l_discount)) AS revenue,
       o.o_orderdate,
       o.o_shippriority
FROM orders o
JOIN lineitem l ON l.l_orderkey = o.o_orderkey
WHERE o.o_custkey IN
    (SELECT c_custkey
     FROM customer
     WHERE c_mktsegment = &&&_A)
  AND o.o_orderdate < date &&&_B
  AND l.l_shipdate > date &&&_C
GROUP BY l.l_orderkey,
         o.o_orderdate,
         o.o_shippriority
ORDER BY revenue DESC,
         o.o_orderdate
LIMIT ###_B;