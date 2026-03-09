WITH calc AS
  (SELECT extract(YEAR
                  FROM o.o_orderdate) AS o_year,
          l.l_extendedprice * (1 - l.l_discount) AS volume,
          n2.n_name AS nation
   FROM part p
   JOIN lineitem l ON p.p_partkey = l.l_partkey
   JOIN orders o ON l.l_orderkey = o.o_orderkey
   JOIN customer c ON o.o_custkey = c.c_custkey
   JOIN nation n1 ON c.c_nationkey = n1.n_nationkey
   JOIN region r ON n1.n_regionkey = r.r_regionkey
   JOIN supplier s ON l.l_suppkey = s.s_suppkey
   JOIN nation n2 ON s.s_nationkey = n2.n_nationkey
   WHERE p.p_type = 'ECONOMY ANODIZED STEEL'
     AND r.r_name = 'AMERICA'
     AND o.o_orderdate BETWEEN date '1995-01-01' AND date '1996-12-31')
SELECT o_year,
       sum(CASE
               WHEN nation = 'BRAZIL' THEN volume
               ELSE 0
           END) / sum(volume) AS mkt_share
FROM calc
GROUP BY o_year
ORDER BY o_year;