
SELECT l.l_orderkey,
       l.rev AS revenue,
       o.o_orderdate,
       o.o_shippriority
FROM
  (SELECT c_custkey
   FROM customer
   WHERE c_mktsegment = &&&_A) c
JOIN
  (SELECT o_orderkey,
          o_custkey,
          o_orderdate,
          o_shippriority
   FROM orders
   WHERE o_orderdate < date &&&_B) o ON c.c_custkey = o.o_custkey
JOIN
  (SELECT l_orderkey,
          sum(l_extendedprice * (###_A - l_discount)) AS rev
   FROM lineitem
   WHERE l_shipdate > date &&&_C
   GROUP BY l_orderkey) l ON l.l_orderkey = o.o_orderkey
ORDER BY revenue DESC,
         o.o_orderdate
LIMIT ###_B;