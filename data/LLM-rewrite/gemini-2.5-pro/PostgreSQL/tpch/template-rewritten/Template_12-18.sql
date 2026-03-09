
SELECT nation,
       o_year,
       sum(amount) AS sum_profit
FROM
  (SELECT n_name AS nation,
          extract(YEAR
                  FROM o_orderdate) AS o_year,
          l_extendedprice * (###_A - l_discount) - ps_supplycost * l_quantity AS amount
   FROM orders,
        lineitem,
        partsupp,
        supplier,
        nation,
        part
   WHERE p_name LIKE &&&_A
     AND p_partkey = l_partkey
     AND ps_partkey = l_partkey
     AND ps_suppkey = l_suppkey
     AND s_suppkey = l_suppkey
     AND s_nationkey = n_nationkey
     AND o_orderkey = l_orderkey) AS profit
GROUP BY nation,
         o_year
ORDER BY nation,
         o_year DESC;