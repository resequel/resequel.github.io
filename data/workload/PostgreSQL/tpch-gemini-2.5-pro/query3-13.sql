
SELECT l.l_orderkey,
       sum(l.l_extendedprice * (1 - l.l_discount)) AS revenue,
       co.o_orderdate,
       co.o_shippriority
FROM
  (SELECT o.o_orderkey,
          o.o_orderdate,
          o.o_shippriority
   FROM customer c
   JOIN orders o ON c.c_custkey = o.o_custkey
   WHERE c.c_mktsegment = 'BUILDING'
     AND o.o_orderdate < date '1995-03-15') co
JOIN lineitem l ON l.l_orderkey = co.o_orderkey
WHERE l.l_shipdate > date '1995-03-15'
GROUP BY l.l_orderkey,
         co.o_orderdate,
         co.o_shippriority
ORDER BY revenue DESC,
         co.o_orderdate
LIMIT 10;