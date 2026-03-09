
SELECT lineitem.l_orderkey,
       sum(lineitem.l_extendedprice * (###_A - lineitem.l_discount)) AS revenue,
       orders.o_orderdate,
       orders.o_shippriority
FROM customer
JOIN orders ON customer.c_custkey = orders.o_custkey
JOIN lineitem ON lineitem.l_orderkey = orders.o_orderkey
WHERE customer.c_mktsegment = &&&_A
  AND orders.o_orderdate < date &&&_B
  AND lineitem.l_shipdate > date &&&_C
GROUP BY lineitem.l_orderkey,
         orders.o_orderdate,
         orders.o_shippriority
ORDER BY revenue DESC,
         orders.o_orderdate
LIMIT ###_B;