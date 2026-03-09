
SELECT n_name AS nation,
       extract(YEAR
               FROM o_orderdate) AS o_year,
       sum(l_extendedprice * (###_A - l_discount) - ps_supplycost * l_quantity) AS sum_profit
FROM part,
     supplier,
     lineitem,
     partsupp,
     orders,
     nation
WHERE p_name LIKE &&&_A
  AND p_partkey = l_partkey
  AND ps_partkey = l_partkey
  AND ps_suppkey = l_suppkey
  AND s_suppkey = l_suppkey
  AND s_nationkey = n_nationkey
  AND o_orderkey = l_orderkey
GROUP BY n_name,
         extract(YEAR
                 FROM o_orderdate)
ORDER BY nation,
         o_year DESC;