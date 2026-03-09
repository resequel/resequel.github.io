
SELECT n_name AS nation,
       extract(YEAR
               FROM o_orderdate) AS o_year,
       sum(l_extendedprice * (###_A - l_discount) - ps_supplycost * l_quantity) AS sum_profit
FROM part p
INNER JOIN partsupp ps ON p.p_partkey = ps.ps_partkey
INNER JOIN lineitem l ON l.l_partkey = ps.ps_partkey
AND l.l_suppkey = ps.ps_suppkey
INNER JOIN supplier s ON l.l_suppkey = s.s_suppkey
INNER JOIN nation n ON s.s_nationkey = n.n_nationkey
INNER JOIN orders o ON l.l_orderkey = o.o_orderkey
WHERE p.p_name LIKE &&&_A
GROUP BY n_name,
         extract(YEAR
                 FROM o_orderdate)
ORDER BY nation,
         o_year DESC;