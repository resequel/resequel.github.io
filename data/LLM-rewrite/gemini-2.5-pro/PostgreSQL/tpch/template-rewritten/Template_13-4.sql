WITH calc AS
  (SELECT extract(YEAR
                  FROM o.o_orderdate) AS o_year,
          l.l_extendedprice * (###_B - l.l_discount) AS volume,
          n2.n_name AS nation
   FROM part p
   JOIN lineitem l ON p.p_partkey = l.l_partkey
   JOIN orders o ON l.l_orderkey = o.o_orderkey
   JOIN customer c ON o.o_custkey = c.c_custkey
   JOIN nation n1 ON c.c_nationkey = n1.n_nationkey
   JOIN region r ON n1.n_regionkey = r.r_regionkey
   JOIN supplier s ON l.l_suppkey = s.s_suppkey
   JOIN nation n2 ON s.s_nationkey = n2.n_nationkey
   WHERE p.p_type = &&&_E
     AND r.r_name = &&&_B
     AND o.o_orderdate BETWEEN date &&&_C AND date &&&_D)
SELECT o_year,
       sum(CASE
               WHEN nation = &&&_A THEN volume
               ELSE ###_A
           END) / sum(volume) AS mkt_share
FROM calc
GROUP BY o_year
ORDER BY o_year;