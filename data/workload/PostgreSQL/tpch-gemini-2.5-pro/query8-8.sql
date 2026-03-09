
SELECT o_year,
       sum(CASE
               WHEN nation = 'BRAZIL' THEN volume
               ELSE 0
           END) / sum(volume) AS mkt_share
FROM
  (SELECT extract(YEAR
                  FROM o_orderdate) AS o_year,
          l_extendedprice * (1 - l_discount) AS volume,
          n2.n_name AS nation
   FROM orders,
        customer,
        nation n1,
        region,
        lineitem,
        part,
        supplier,
        nation n2
   WHERE o_orderdate BETWEEN date '1995-01-01' AND date '1996-12-31'
     AND o_custkey = c_custkey
     AND c_nationkey = n1.n_nationkey
     AND n1.n_regionkey = r_regionkey
     AND r_name = 'AMERICA'
     AND o_orderkey = l_orderkey
     AND l_partkey = p_partkey
     AND p_type = 'ECONOMY ANODIZED STEEL'
     AND l_suppkey = s_suppkey
     AND s_nationkey = n2.n_nationkey) AS all_nations
GROUP BY o_year
ORDER BY o_year;