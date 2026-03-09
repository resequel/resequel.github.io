
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
   FROM lineitem
   INNER JOIN orders ON l_orderkey = o_orderkey
   INNER JOIN customer ON o_custkey = c_custkey
   INNER JOIN nation n1 ON c_nationkey = n1.n_nationkey
   INNER JOIN region ON n1.n_regionkey = r_regionkey
   INNER JOIN part ON l_partkey = p_partkey
   INNER JOIN supplier ON l_suppkey = s_suppkey
   INNER JOIN nation n2 ON s_nationkey = n2.n_nationkey
   WHERE o_orderdate BETWEEN date '1995-01-01' AND date '1996-12-31'
     AND r_name = 'AMERICA'
     AND p_type = 'ECONOMY ANODIZED STEEL') AS all_nations
GROUP BY o_year
ORDER BY o_year;