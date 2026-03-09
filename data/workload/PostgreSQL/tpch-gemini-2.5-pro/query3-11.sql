WITH l AS
  (SELECT l_orderkey,
          l_extendedprice,
          l_discount
   FROM lineitem
   WHERE l_shipdate > date '1995-03-15')
SELECT l.l_orderkey,
       sum(l.l_extendedprice * (1 - l.l_discount)) AS revenue,
       o.o_orderdate,
       o.o_shippriority
FROM customer c
JOIN orders o ON c.c_custkey = o.o_custkey
JOIN l ON l.l_orderkey = o.o_orderkey
WHERE c.c_mktsegment = 'BUILDING'
  AND o.o_orderdate < date '1995-03-15'
GROUP BY l.l_orderkey,
         o.o_orderdate,
         o.o_shippriority
ORDER BY revenue DESC,
         o.o_orderdate
LIMIT 10;