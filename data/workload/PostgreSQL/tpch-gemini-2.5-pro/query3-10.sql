
SELECT lineitem.l_orderkey,
       sum(lineitem.l_extendedprice * (1 - lineitem.l_discount)) AS revenue,
       orders.o_orderdate,
       orders.o_shippriority
FROM customer
JOIN orders ON customer.c_custkey = orders.o_custkey
JOIN lineitem ON lineitem.l_orderkey = orders.o_orderkey
WHERE customer.c_mktsegment = 'BUILDING'
  AND orders.o_orderdate < date '1995-03-15'
  AND lineitem.l_shipdate > date '1995-03-15'
GROUP BY lineitem.l_orderkey,
         orders.o_orderdate,
         orders.o_shippriority
ORDER BY revenue DESC,
         orders.o_orderdate
LIMIT 10;