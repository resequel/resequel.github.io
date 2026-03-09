
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
   FROM region
   INNER JOIN nation n1 ON r_regionkey = n1.n_regionkey
   INNER JOIN customer ON n1.n_nationkey = c_nationkey
   INNER JOIN orders ON c_custkey = o_custkey
   INNER JOIN lineitem ON o_orderkey = l_orderkey
   INNER JOIN part ON l_partkey = p_partkey
   INNER JOIN supplier ON l_suppkey = s_suppkey
   INNER JOIN nation n2 ON s_nationkey = n2.n_nationkey
   WHERE r_name = 'AMERICA'
     AND o_orderdate BETWEEN date '1995-01-01' AND date '1996-12-31'
     AND p_type = 'ECONOMY ANODIZED STEEL') AS all_nations
GROUP BY o_year
ORDER BY o_year;