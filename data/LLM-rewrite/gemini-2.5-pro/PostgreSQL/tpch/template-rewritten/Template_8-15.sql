
SELECT n_name,
       sum(l_extendedprice * (###_A - l_discount)) AS revenue
FROM region,
     nation,
     supplier,
     customer,
     orders,
     lineitem
WHERE r_regionkey = n_regionkey
  AND n_nationkey = s_nationkey
  AND n_nationkey = c_nationkey
  AND c_custkey = o_custkey
  AND o_orderkey = l_orderkey
  AND s_suppkey = l_suppkey
  AND r_name = &&&_A
  AND o_orderdate >= date &&&_B
  AND o_orderdate < date &&&_C + interval &&&_D YEAR
GROUP BY n_name
ORDER BY revenue DESC;