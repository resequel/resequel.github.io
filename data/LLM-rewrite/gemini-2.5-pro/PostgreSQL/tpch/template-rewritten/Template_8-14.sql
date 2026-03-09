
SELECT n_name,
       sum(l_extendedprice * (###_A - l_discount)) AS revenue
FROM lineitem
INNER JOIN orders ON l_orderkey = o_orderkey
INNER JOIN customer ON o_custkey = c_custkey
INNER JOIN supplier ON l_suppkey = s_suppkey
INNER JOIN nation ON c_nationkey = n_nationkey
AND s_nationkey = n_nationkey
INNER JOIN region ON n_regionkey = r_regionkey
WHERE r_name = &&&_A
  AND o_orderdate >= date &&&_B
  AND o_orderdate < date &&&_C + interval &&&_D YEAR
GROUP BY n_name
ORDER BY revenue DESC;