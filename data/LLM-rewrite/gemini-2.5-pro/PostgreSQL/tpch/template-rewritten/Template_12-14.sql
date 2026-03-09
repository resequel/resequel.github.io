
SELECT n.n_name AS nation,
       extract(YEAR
               FROM o.o_orderdate) AS o_year,
       sum(l.l_extendedprice * (###_A - l.l_discount) - ps.ps_supplycost * l.l_quantity) AS sum_profit
FROM supplier s
INNER JOIN nation n ON s.s_nationkey = n.n_nationkey
INNER JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey
INNER JOIN part p ON p.p_partkey = ps.ps_partkey
INNER JOIN lineitem l ON l.l_partkey = ps.ps_partkey
AND l.l_suppkey = ps.ps_suppkey
INNER JOIN orders o ON o.o_orderkey = l.l_orderkey
WHERE p.p_name LIKE &&&_A
GROUP BY n.n_name,
         extract(YEAR
                 FROM o.o_orderdate)
ORDER BY nation,
         o_year DESC;