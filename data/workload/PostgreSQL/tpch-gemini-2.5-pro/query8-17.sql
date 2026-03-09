
SELECT o_year,
       sum(CASE
               WHEN nation = 'BRAZIL' THEN volume
               ELSE 0
           END) / sum(volume) AS mkt_share
FROM
  (SELECT extract(YEAR
                  FROM o.o_orderdate) AS o_year,
          l.l_extendedprice * (1 - l.l_discount) AS volume,
          n2.n_name AS nation
   FROM lineitem l
   INNER JOIN part p ON l.l_partkey = p.p_partkey
   INNER JOIN orders o ON l.l_orderkey = o.o_orderkey
   INNER JOIN customer c ON o.o_custkey = c.c_custkey
   INNER JOIN nation n1 ON c.c_nationkey = n1.n_nationkey
   INNER JOIN region r ON n1.n_regionkey = r.r_regionkey
   INNER JOIN supplier s ON l.l_suppkey = s.s_suppkey
   INNER JOIN nation n2 ON s.s_nationkey = n2.n_nationkey
   WHERE p.p_type = 'ECONOMY ANODIZED STEEL'
     AND r.r_name = 'AMERICA'
     AND o.o_orderdate BETWEEN date '1995-01-01' AND date '1996-12-31') AS all_nations
GROUP BY o_year
ORDER BY o_year;