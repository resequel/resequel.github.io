
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
   FROM part,
        supplier,
        nation n2,
        lineitem,
        orders,
        customer,
        nation n1,
        region
   WHERE p_type = 'ECONOMY ANODIZED STEEL'
     AND p_partkey = l_partkey
     AND s_suppkey = l_suppkey
     AND s_nationkey = n2.n_nationkey
     AND l_orderkey = o_orderkey
     AND o_orderdate BETWEEN date '1995-01-01' AND date '1996-12-31'
     AND o_custkey = c_custkey
     AND c_nationkey = n1.n_nationkey
     AND n1.n_regionkey = r_regionkey
     AND r_name = 'AMERICA') AS all_nations
GROUP BY o_year
ORDER BY o_year;