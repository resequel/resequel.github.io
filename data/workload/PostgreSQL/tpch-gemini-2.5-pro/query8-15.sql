
SELECT all_nations.o_year,
       sum(CASE
               WHEN all_nations.nation = 'BRAZIL' THEN all_nations.volume
               ELSE 0
           END) / sum(all_nations.volume) AS mkt_share
FROM
  (SELECT extract(YEAR
                  FROM o.o_orderdate) AS o_year,
          l.l_extendedprice * (1 - l.l_discount) AS volume,
          n2.n_name AS nation
   FROM region r
   JOIN nation n1 ON r.r_regionkey = n1.n_regionkey
   JOIN customer c ON n1.n_nationkey = c.c_nationkey
   JOIN orders o ON c.c_custkey = o.o_custkey
   JOIN part p ON p.p_type = 'ECONOMY ANODIZED STEEL'
   JOIN lineitem l ON o.o_orderkey = l.l_orderkey
   AND p.p_partkey = l.l_partkey
   JOIN supplier s ON l.l_suppkey = s.s_suppkey
   JOIN nation n2 ON s.s_nationkey = n2.n_nationkey
   WHERE r.r_name = 'AMERICA'
     AND o.o_orderdate BETWEEN date '1995-01-01' AND date '1996-12-31') AS all_nations
GROUP BY all_nations.o_year
ORDER BY all_nations.o_year;