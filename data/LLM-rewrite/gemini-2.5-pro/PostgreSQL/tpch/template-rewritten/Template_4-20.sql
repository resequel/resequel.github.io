
SELECT l_orderkey,
       sum(l_extendedprice * (###_A - l_discount)) AS revenue,
       o_orderdate,
       o_shippriority
FROM customer,
     orders,
     lineitem
WHERE c_mktsegment = &&&_A
  AND c_custkey = o_custkey
  AND l_orderkey = o_orderkey
  AND o_orderdate < date &&&_B
  AND l_shipdate > date &&&_C
GROUP BY l_orderkey,
         o_orderdate,
         o_shippriority
ORDER BY revenue DESC,
         o_orderdate
LIMIT ###_B;