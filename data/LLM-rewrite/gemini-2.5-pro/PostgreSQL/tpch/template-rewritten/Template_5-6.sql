
SELECT ps.ps_partkey,
       sum(ps.ps_supplycost * ps.ps_availqty) AS value
FROM partsupp ps
JOIN
  (SELECT s.s_suppkey
   FROM supplier s
   JOIN nation n ON s.s_nationkey = n.n_nationkey
   WHERE n.n_name = &&&_A) ts ON ps.ps_suppkey = ts.s_suppkey
GROUP BY ps.ps_partkey
HAVING sum(ps.ps_supplycost * ps.ps_availqty) >
  (SELECT sum(ps2.ps_supplycost * ps2.ps_availqty) * ^^^_A
   FROM partsupp ps2
   JOIN supplier s2 ON ps2.ps_suppkey = s2.s_suppkey
   JOIN nation n2 ON s2.s_nationkey = n2.n_nationkey
   WHERE n2.n_name = &&&_B)
ORDER BY value DESC;