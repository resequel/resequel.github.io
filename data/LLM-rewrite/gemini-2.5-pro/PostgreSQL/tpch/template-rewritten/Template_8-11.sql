
SELECT n_name,
       sum(l_extendedprice * (###_A - l_discount)) AS revenue
FROM region
INNER JOIN nation ON n_regionkey = r_regionkey
INNER JOIN customer ON c_nationkey = n_nationkey
INNER JOIN supplier ON s_nationkey = n_nationkey
INNER JOIN orders ON o_custkey = c_custkey
INNER JOIN lineitem ON l_orderkey = o_orderkey
AND l_suppkey = s_suppkey
WHERE r_name = &&&_A
  AND o_orderdate >= date &&&_B
  AND o_orderdate < date &&&_C + interval &&&_D YEAR
GROUP BY n_name
ORDER BY revenue DESC;