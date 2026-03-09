WITH thresh AS
  (SELECT sum(ps.ps_supplycost * ps.ps_availqty) * 0.0001 AS val
   FROM partsupp ps
   JOIN supplier s ON ps.ps_suppkey = s.s_suppkey
   JOIN nation n ON s.s_nationkey = n.n_nationkey
   WHERE n.n_name = 'GERMANY')
SELECT ps.ps_partkey,
       sum(ps.ps_supplycost * ps.ps_availqty) AS value
FROM partsupp ps
JOIN
  (SELECT s.s_suppkey
   FROM supplier s
   JOIN nation n ON s.s_nationkey = n.n_nationkey
   WHERE n.n_name = 'GERMANY') ts ON ps.ps_suppkey = ts.s_suppkey
GROUP BY ps.ps_partkey
HAVING sum(ps.ps_supplycost * ps.ps_availqty) >
  (SELECT val
   FROM thresh)
ORDER BY value DESC;