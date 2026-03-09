
SELECT n_name,
       sum(l_extendedprice * (1 - l_discount)) AS revenue
FROM region
INNER JOIN nation ON n_regionkey = r_regionkey
INNER JOIN customer ON c_nationkey = n_nationkey
INNER JOIN supplier ON s_nationkey = n_nationkey
INNER JOIN orders ON o_custkey = c_custkey
INNER JOIN lineitem ON l_orderkey = o_orderkey
AND l_suppkey = s_suppkey
WHERE r_name = 'ASIA'
  AND o_orderdate >= date '1994-01-01'
  AND o_orderdate < date '1994-01-01' + interval '1' YEAR
GROUP BY n_name
ORDER BY revenue DESC;