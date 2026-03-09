
SELECT nation.n_name,
       sum(lineitem.l_extendedprice * (###_A - lineitem.l_discount)) AS revenue
FROM region
JOIN nation ON region.r_regionkey = nation.n_regionkey
JOIN supplier ON nation.n_nationkey = supplier.s_nationkey
JOIN customer ON nation.n_nationkey = customer.c_nationkey
JOIN orders ON customer.c_custkey = orders.o_custkey
JOIN lineitem ON orders.o_orderkey = lineitem.l_orderkey
AND supplier.s_suppkey = lineitem.l_suppkey
WHERE region.r_name = &&&_A
  AND orders.o_orderdate >= date &&&_B
  AND orders.o_orderdate < date &&&_C + interval &&&_D YEAR
GROUP BY nation.n_name
ORDER BY revenue DESC;