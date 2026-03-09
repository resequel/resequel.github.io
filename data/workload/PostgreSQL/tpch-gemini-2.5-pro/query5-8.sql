
SELECT nation.n_name,
       sum(lineitem.l_extendedprice * (1 - lineitem.l_discount)) AS revenue
FROM region
JOIN nation ON region.r_regionkey = nation.n_regionkey
JOIN supplier ON nation.n_nationkey = supplier.s_nationkey
JOIN customer ON nation.n_nationkey = customer.c_nationkey
JOIN orders ON customer.c_custkey = orders.o_custkey
JOIN lineitem ON orders.o_orderkey = lineitem.l_orderkey
AND supplier.s_suppkey = lineitem.l_suppkey
WHERE region.r_name = 'ASIA'
  AND orders.o_orderdate >= date '1994-01-01'
  AND orders.o_orderdate < date '1994-01-01' + interval '1' YEAR
GROUP BY nation.n_name
ORDER BY revenue DESC;