
SELECT n_name,
       sum(l_extendedprice * (###_A - l_discount)) AS revenue
FROM customer,
     orders,
     lineitem,
     supplier,
     nation,
     region
WHERE c_custkey = o_custkey
  AND l_orderkey = o_orderkey
  AND l_suppkey = s_suppkey
  AND c_nationkey = n_nationkey
  AND s_nationkey = n_nationkey
  AND n_regionkey = r_regionkey
  AND r_name = &&&_A
  AND o_orderdate >= date &&&_B
  AND o_orderdate < date &&&_C + interval &&&_D YEAR
GROUP BY n_name
ORDER BY revenue DESC;