WITH c AS MATERIALIZED
  (SELECT c_custkey
   FROM customer
   WHERE c_mktsegment = &&&_A),
     o AS MATERIALIZED
  (SELECT o_orderkey, o_custkey, o_orderdate, o_shippriority
   FROM orders
   WHERE o_orderdate < date &&&_B)
SELECT l.l_orderkey,
       sum(l.l_extendedprice * (###_A - l.l_discount)) AS revenue,
       o.o_orderdate,
       o.o_shippriority
FROM c
JOIN o ON c.c_custkey = o.o_custkey
JOIN lineitem l ON l.l_orderkey = o.o_orderkey
WHERE l.l_shipdate > date &&&_C
GROUP BY l.l_orderkey,
         o.o_orderdate,
         o.o_shippriority
ORDER BY revenue DESC,
         o.o_orderdate
LIMIT ###_B;