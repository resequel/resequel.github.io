WITH thresh AS MATERIALIZED
  (SELECT sum(ps_supplycost * ps_availqty) * ^^^_A AS val
   FROM partsupp
   JOIN supplier ON ps_suppkey = s_suppkey
   JOIN nation ON s_nationkey = n_nationkey
   WHERE n_name = &&&_B)
SELECT ps.ps_partkey,
       sum(ps.ps_supplycost * ps.ps_availqty) AS value
FROM partsupp ps
JOIN supplier s ON ps.ps_suppkey = s.s_suppkey
JOIN nation n ON s.s_nationkey = n.n_nationkey
WHERE n.n_name = &&&_A
GROUP BY ps.ps_partkey
HAVING sum(ps.ps_supplycost * ps.ps_availqty) >
  (SELECT val
   FROM thresh)
ORDER BY value DESC;