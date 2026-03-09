
SELECT n_name,
       sum(l_extendedprice * (1 - l_discount)) AS revenue
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
  AND r_name = 'ASIA'
  AND o_orderdate >= date '1994-01-01'
  AND o_orderdate < date '1994-01-01' + interval '1' YEAR
GROUP BY n_name
ORDER BY revenue DESC;