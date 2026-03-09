
SELECT extract(YEAR
               FROM o.o_orderdate) AS o_year,
       sum(CASE
               WHEN n2.n_name = &&&_A THEN l.l_extendedprice * (###_B - l.l_discount)
               ELSE ###_A
           END) / sum(l.l_extendedprice * (###_B - l.l_discount)) AS mkt_share
FROM part p
INNER JOIN lineitem l ON p.p_partkey = l.l_partkey
INNER JOIN orders o ON l.l_orderkey = o.o_orderkey
INNER JOIN customer c ON o.o_custkey = c.c_custkey
INNER JOIN nation n1 ON c.c_nationkey = n1.n_nationkey
INNER JOIN region r ON n1.n_regionkey = r.r_regionkey
INNER JOIN supplier s ON l.l_suppkey = s.s_suppkey
INNER JOIN nation n2 ON s.s_nationkey = n2.n_nationkey
WHERE p.p_type = &&&_E
  AND r.r_name = &&&_B
  AND o.o_orderdate BETWEEN date &&&_C AND date &&&_D
GROUP BY extract(YEAR
                 FROM o.o_orderdate)
ORDER BY o_year;