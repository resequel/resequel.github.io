WITH filtered_orders AS
  (SELECT o.o_orderkey,
          o.o_orderdate,
          o.o_shippriority
   FROM orders o
   JOIN customer c ON o.o_custkey = c.c_custkey
   WHERE c.c_mktsegment = 'BUILDING'
     AND o.o_orderdate < date '1995-03-15')
SELECT l.l_orderkey,
       sum(l.l_extendedprice * (1 - l.l_discount)) AS revenue,
       fo.o_orderdate,
       fo.o_shippriority
FROM filtered_orders fo
JOIN lineitem l ON fo.o_orderkey = l.l_orderkey
WHERE l.l_shipdate > date '1995-03-15'
GROUP BY l.l_orderkey,
         fo.o_orderdate,
         fo.o_shippriority
ORDER BY revenue DESC,
         fo.o_orderdate
LIMIT 10;