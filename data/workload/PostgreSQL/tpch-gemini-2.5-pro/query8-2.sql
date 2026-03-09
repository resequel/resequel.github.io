WITH p AS
  (SELECT p_partkey
   FROM part
   WHERE p_type = 'ECONOMY ANODIZED STEEL'),
     o AS
  (SELECT o_orderkey,
          o_custkey,
          extract(YEAR
                  FROM o_orderdate) AS o_year
   FROM orders
   WHERE o_orderdate BETWEEN date '1995-01-01' AND date '1996-12-31'),
     cr AS
  (SELECT c.c_custkey
   FROM customer c
   JOIN nation n1 ON c.c_nationkey = n1.n_nationkey
   JOIN region r ON n1.n_regionkey = r.r_regionkey
   WHERE r.r_name = 'AMERICA'),
     s AS
  (SELECT s.s_suppkey,
          n2.n_name AS nation
   FROM supplier s
   JOIN nation n2 ON s.s_nationkey = n2.n_nationkey)
SELECT o.o_year,
       sum(CASE
               WHEN s.nation = 'BRAZIL' THEN l.l_extendedprice * (1 - l.l_discount)
               ELSE 0
           END) / sum(l.l_extendedprice * (1 - l.l_discount)) AS mkt_share
FROM p
JOIN lineitem l ON p.p_partkey = l.l_partkey
JOIN o ON l.l_orderkey = o.o_orderkey
JOIN cr ON o.o_custkey = cr.c_custkey
JOIN s ON l.l_suppkey = s.s_suppkey
GROUP BY o.o_year
ORDER BY o.o_year;