
SELECT l_orderkey,
       sum(l_extendedprice * (1 - l_discount)) AS revenue,
       o_orderdate,
       o_shippriority
FROM customer
INNER JOIN orders ON c_custkey = o_custkey
AND c_mktsegment = 'BUILDING'
AND o_orderdate < date '1995-03-15'
INNER JOIN lineitem ON l_orderkey = o_orderkey
AND l_shipdate > date '1995-03-15'
GROUP BY l_orderkey,
         o_orderdate,
         o_shippriority
ORDER BY revenue DESC,
         o_orderdate
LIMIT 10;