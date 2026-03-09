
SELECT o_year,
       sum(CASE
               WHEN nation = &&&_A THEN volume
               ELSE ###_A
           END) / sum(volume) AS mkt_share
FROM
  (SELECT extract(YEAR
                  FROM o_orderdate) AS o_year,
          l_extendedprice * (###_B - l_discount) AS volume,
          n2.n_name AS nation
   FROM orders,
        customer,
        nation n1,
        region,
        lineitem,
        part,
        supplier,
        nation n2
   WHERE o_orderdate BETWEEN date &&&_C AND date &&&_D
     AND o_custkey = c_custkey
     AND c_nationkey = n1.n_nationkey
     AND n1.n_regionkey = r_regionkey
     AND r_name = &&&_B
     AND o_orderkey = l_orderkey
     AND l_partkey = p_partkey
     AND p_type = &&&_E
     AND l_suppkey = s_suppkey
     AND s_nationkey = n2.n_nationkey) AS all_nations
GROUP BY o_year
ORDER BY o_year;