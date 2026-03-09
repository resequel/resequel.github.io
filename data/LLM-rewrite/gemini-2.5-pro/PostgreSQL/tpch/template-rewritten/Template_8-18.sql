
SELECT n_name,
       sum(l_extendedprice * (###_A - l_discount)) AS revenue
FROM customer,
     orders,
     lineitem,
     supplier,
     nation,
     region
WHERE o_orderdate >= date &&&_B
  AND o_orderdate < date &&&_C + interval &&&_D YEAR
  AND r_name = &&&_A
  AND n_regionkey = r_regionkey
  AND s_nationkey = n_nationkey
  AND c_nationkey = s_nationkey
  AND l_suppkey = s_suppkey
  AND c_custkey = o_custkey
  AND l_orderkey = o_orderkey
GROUP BY n_name
ORDER BY revenue DESC;