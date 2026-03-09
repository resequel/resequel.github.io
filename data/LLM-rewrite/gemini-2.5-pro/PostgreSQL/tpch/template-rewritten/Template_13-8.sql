
SELECT all_nations.o_year,
       sum(CASE
               WHEN all_nations.nation = &&&_A THEN calc.volume
               ELSE ###_A
           END) / sum(calc.volume) AS mkt_share
FROM
  (SELECT extract(YEAR
                  FROM o.o_orderdate) AS o_year,
          l.l_extendedprice,
          l.l_discount,
          n2.n_name AS nation
   FROM part p
   INNER JOIN lineitem l ON p.p_partkey = l.l_partkey
   INNER JOIN supplier s ON l.l_suppkey = s.s_suppkey
   INNER JOIN nation n2 ON s.s_nationkey = n2.n_nationkey
   INNER JOIN orders o ON l.l_orderkey = o.o_orderkey
   INNER JOIN customer c ON o.o_custkey = c.c_custkey
   INNER JOIN nation n1 ON c.c_nationkey = n1.n_nationkey
   INNER JOIN region r ON n1.n_regionkey = r.r_regionkey
   WHERE p.p_type = &&&_E
     AND r.r_name = &&&_B
     AND o.o_orderdate BETWEEN date &&&_C AND date &&&_D) AS all_nations
CROSS JOIN LATERAL
  (SELECT all_nations.l_extendedprice * (###_B - all_nations.l_discount) AS volume) calc
GROUP BY all_nations.o_year
ORDER BY all_nations.o_year;