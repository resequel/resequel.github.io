
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
   FROM part
   INNER JOIN supplier ON TRUE
   INNER JOIN lineitem ON p_partkey = l_partkey
   AND s_suppkey = l_suppkey
   INNER JOIN orders ON l_orderkey = o_orderkey
   INNER JOIN customer ON o_custkey = c_custkey
   INNER JOIN nation n1 ON c_nationkey = n1.n_nationkey
   INNER JOIN region ON n1.n_regionkey = r_regionkey
   INNER JOIN nation n2 ON s_nationkey = n2.n_nationkey
   WHERE p_type = &&&_E
     AND r_name = &&&_B
     AND o_orderdate BETWEEN date &&&_C AND date &&&_D) AS all_nations
GROUP BY o_year
ORDER BY o_year;