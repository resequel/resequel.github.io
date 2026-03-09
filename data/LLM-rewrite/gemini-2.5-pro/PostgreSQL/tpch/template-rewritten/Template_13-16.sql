
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
   FROM region,
        nation n1,
        customer,
        orders,
        lineitem,
        part,
        supplier,
        nation n2
   WHERE r_name = &&&_B
     AND n1.n_regionkey = r_regionkey
     AND c_nationkey = n1.n_nationkey
     AND o_custkey = c_custkey
     AND o_orderdate BETWEEN date &&&_C AND date &&&_D
     AND l_orderkey = o_orderkey
     AND l_partkey = p_partkey
     AND p_type = &&&_E
     AND l_suppkey = s_suppkey
     AND s_nationkey = n2.n_nationkey) AS all_nations
GROUP BY o_year
ORDER BY o_year;