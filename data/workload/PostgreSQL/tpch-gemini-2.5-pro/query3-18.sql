WITH co AS
  (SELECT o.o_orderkey,
          o.o_orderdate,
          o.o_shippriority
   FROM customer c
   JOIN orders o ON c.c_custkey = o.o_custkey
   WHERE c.c_mktsegment = 'BUILDING'
     AND o.o_orderdate < date '1995-03-15'),
     l AS
  (SELECT l_orderkey,
          sum(l_extendedprice * (1 - l_discount)) AS rev
   FROM lineitem
   WHERE l_shipdate > date '1995-03-15'
   GROUP BY l_orderkey)
SELECT co.o_orderkey AS l_orderkey,
       l.rev AS revenue,
       co.o_orderdate,
       co.o_shippriority
FROM co
JOIN l ON co.o_orderkey = l.l_orderkey
ORDER BY revenue DESC,
         co.o_orderdate
LIMIT 10;