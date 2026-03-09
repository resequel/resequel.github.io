
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
   FROM region
   INNER JOIN nation n1 ON r_regionkey = n1.n_regionkey
   INNER JOIN customer ON n1.n_nationkey = c_nationkey
   INNER JOIN orders ON c_custkey = o_custkey
   INNER JOIN lineitem ON o_orderkey = l_orderkey
   INNER JOIN part ON l_partkey = p_partkey
   INNER JOIN supplier ON l_suppkey = s_suppkey
   INNER JOIN nation n2 ON s_nationkey = n2.n_nationkey
   WHERE r_name = &&&_B
     AND o_orderdate BETWEEN date &&&_C AND date &&&_D
     AND p_type = &&&_E) AS all_nations
GROUP BY o_year
ORDER BY o_year;