
SELECT n_name,
       sum(l_extendedprice * (1 - l_discount)) AS revenue
FROM lineitem
INNER JOIN orders ON l_orderkey = o_orderkey
INNER JOIN customer ON o_custkey = c_custkey
INNER JOIN supplier ON l_suppkey = s_suppkey
INNER JOIN nation ON c_nationkey = n_nationkey
AND s_nationkey = n_nationkey
INNER JOIN region ON n_regionkey = r_regionkey
WHERE r_name = 'ASIA'
  AND o_orderdate >= date '1994-01-01'
  AND o_orderdate < date '1994-01-01' + interval '1' YEAR
GROUP BY n_name
ORDER BY revenue DESC;