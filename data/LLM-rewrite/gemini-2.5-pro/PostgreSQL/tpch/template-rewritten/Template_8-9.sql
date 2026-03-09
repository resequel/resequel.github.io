WITH o_filtered AS
  (SELECT o_orderkey,
          o_custkey
   FROM orders
   WHERE o_orderdate >= date &&&_B
     AND o_orderdate < date &&&_C + interval &&&_D YEAR)
SELECT n_name,
       sum(l_extendedprice * (###_A - l_discount)) AS revenue
FROM region
JOIN nation ON r_regionkey = n_regionkey
JOIN customer ON n_nationkey = c_nationkey
JOIN supplier ON n_nationkey = s_nationkey
JOIN o_filtered ON c_custkey = o_custkey
JOIN lineitem ON o_orderkey = l_orderkey
AND s_suppkey = l_suppkey
WHERE r_name = &&&_A
GROUP BY n_name
ORDER BY revenue DESC;