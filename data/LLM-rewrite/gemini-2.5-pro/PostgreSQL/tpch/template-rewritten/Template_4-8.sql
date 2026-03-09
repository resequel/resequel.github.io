WITH l AS
  (SELECT l_orderkey,
          l_extendedprice,
          l_discount
   FROM lineitem
   WHERE l_shipdate > date &&&_C)
SELECT l.l_orderkey,
       sum(l.l_extendedprice * (###_A - l.l_discount)) AS revenue,
       o.o_orderdate,
       o.o_shippriority
FROM customer c
JOIN orders o ON c.c_custkey = o.o_custkey
JOIN l ON l.l_orderkey = o.o_orderkey
WHERE c.c_mktsegment = &&&_A
  AND o.o_orderdate < date &&&_B
GROUP BY l.l_orderkey,
         o.o_orderdate,
         o.o_shippriority
ORDER BY revenue DESC,
         o.o_orderdate
LIMIT ###_B;