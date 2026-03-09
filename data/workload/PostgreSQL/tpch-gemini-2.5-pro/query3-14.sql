WITH c AS
  (SELECT c_custkey
   FROM customer
   WHERE c_mktsegment = 'BUILDING'),
     o AS
  (SELECT o_orderkey,
          o_custkey,
          o_orderdate,
          o_shippriority
   FROM orders
   WHERE o_orderdate < date '1995-03-15'),
     l AS
  (SELECT l_orderkey,
          sum(l_extendedprice * (1 - l_discount)) AS rev
   FROM lineitem
   WHERE l_shipdate > date '1995-03-15'
   GROUP BY l_orderkey)
SELECT l.l_orderkey,
       l.rev AS revenue,
       o.o_orderdate,
       o.o_shippriority
FROM c
JOIN o ON c.c_custkey = o.o_custkey
JOIN l ON l.l_orderkey = o.o_orderkey
ORDER BY revenue DESC,
         o.o_orderdate
LIMIT 10;