WITH filtered_orders AS
  (SELECT o.o_orderkey,
          o.o_orderdate,
          o.o_shippriority
   FROM orders o
   JOIN customer c ON o.o_custkey = c.c_custkey
   WHERE c.c_mktsegment = &&&_A
     AND o.o_orderdate < date &&&_B)
SELECT l.l_orderkey,
       sum(l.l_extendedprice * (###_A - l.l_discount)) AS revenue,
       fo.o_orderdate,
       fo.o_shippriority
FROM filtered_orders fo
JOIN lineitem l ON fo.o_orderkey = l.l_orderkey
WHERE l.l_shipdate > date &&&_C
GROUP BY l.l_orderkey,
         fo.o_orderdate,
         fo.o_shippriority
ORDER BY revenue DESC,
         fo.o_orderdate
LIMIT ###_B;