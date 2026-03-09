WITH threshold AS
  (SELECT SUM(ps.ps_supplycost * ps.ps_availqty) * 0.0001 AS thr
   FROM partsupp ps
   JOIN supplier s ON ps.ps_suppkey = s.s_suppkey
   JOIN nation n ON s.s_nationkey = n.n_nationkey
   WHERE n.n_name = 'GERMANY')
SELECT ps.ps_partkey,
       SUM(ps.ps_supplycost * ps.ps_availqty) AS value
FROM partsupp ps
JOIN supplier s ON ps.ps_suppkey = s.s_suppkey
JOIN nation n ON s.s_nationkey = n.n_nationkey
WHERE n.n_name = 'GERMANY'
GROUP BY ps.ps_partkey
HAVING SUM(ps.ps_supplycost * ps.ps_availqty) >
  (SELECT thr
   FROM threshold)
ORDER BY value DESC;