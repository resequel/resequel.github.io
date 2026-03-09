WITH p AS
  (SELECT p_partkey
   FROM part
   WHERE p_name LIKE &&&_A)
SELECT n.n_name AS nation,
       extract(YEAR
               FROM o.o_orderdate) AS o_year,
       sum(l.l_extendedprice * (###_A - l.l_discount) - ps.ps_supplycost * l.l_quantity) AS sum_profit
FROM p
JOIN lineitem l ON p.p_partkey = l.l_partkey
JOIN partsupp ps ON l.l_partkey = ps.ps_partkey
AND l.l_suppkey = ps.ps_suppkey
JOIN supplier s ON l.l_suppkey = s.s_suppkey
JOIN nation n ON s.s_nationkey = n.n_nationkey
JOIN orders o ON l.l_orderkey = o.o_orderkey
GROUP BY n.n_name,
         extract(YEAR
                 FROM o.o_orderdate)
ORDER BY nation,
         o_year DESC;