
SELECT lo.l_orderkey,
       sum(lo.rev) AS revenue,
       lo.o_orderdate,
       lo.o_shippriority
FROM
  (SELECT l.l_orderkey,
          l.l_extendedprice * (1 - l.l_discount) AS rev,
          o.o_custkey,
          o.o_orderdate,
          o.o_shippriority
   FROM lineitem l
   JOIN orders o ON l.l_orderkey = o.o_orderkey
   WHERE o.o_orderdate < date '1995-03-15'
     AND l.l_shipdate > date '1995-03-15') lo
JOIN customer c ON lo.o_custkey = c.c_custkey
WHERE c.c_mktsegment = 'BUILDING'
GROUP BY lo.l_orderkey,
         lo.o_orderdate,
         lo.o_shippriority
ORDER BY revenue DESC,
         lo.o_orderdate
LIMIT 10;