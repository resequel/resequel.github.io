
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
   FROM orders o
   JOIN customer c ON o.o_custkey = c.c_custkey
   JOIN nation n1 ON c.c_nationkey = n1.n_nationkey
   JOIN region r ON n1.n_regionkey = r.r_regionkey
   JOIN lineitem l ON o.o_orderkey = l.l_orderkey
   JOIN part p ON p.p_partkey = l.l_partkey
   JOIN supplier s ON s.s_suppkey = l.l_suppkey
   JOIN nation n2 ON s.s_nationkey = n2.n_nationkey
   WHERE r.r_name = &&&_B
     AND o.o_orderdate BETWEEN date &&&_C AND date &&&_D
     AND p.p_type = &&&_E) AS all_nations
GROUP BY o_year
ORDER BY o_year;