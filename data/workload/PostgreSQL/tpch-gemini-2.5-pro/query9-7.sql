WITH profit AS
  (SELECT n.n_name AS nation,
          extract(YEAR
                  FROM o.o_orderdate) AS o_year,
          l.l_extendedprice * (1 - l.l_discount) - ps.ps_supplycost * l.l_quantity AS amount
   FROM part p
   JOIN lineitem l ON p.p_partkey = l.l_partkey
   JOIN partsupp ps ON l.l_partkey = ps.ps_partkey
   AND l.l_suppkey = ps.ps_suppkey
   JOIN supplier s ON l.l_suppkey = s.s_suppkey
   JOIN nation n ON s.s_nationkey = n.n_nationkey
   JOIN orders o ON l.l_orderkey = o.o_orderkey
   WHERE p.p_name LIKE '%green%')
SELECT nation,
       o_year,
       sum(amount) AS sum_profit
FROM profit
GROUP BY nation,
         o_year
ORDER BY nation,
         o_year DESC;