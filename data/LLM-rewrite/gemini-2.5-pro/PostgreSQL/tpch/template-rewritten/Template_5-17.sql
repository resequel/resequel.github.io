
SELECT ps.ps_partkey,
       sum(ps.ps_supplycost * ps.ps_availqty) AS value
FROM partsupp ps
INNER JOIN supplier s ON ps.ps_suppkey = s.s_suppkey
INNER JOIN nation n ON s.s_nationkey = n.n_nationkey
WHERE n.n_name = &&&_A
GROUP BY ps.ps_partkey
HAVING sum(ps.ps_supplycost * ps.ps_availqty) >
  (SELECT sum(ps_supplycost * ps_availqty) * ^^^_A
   FROM partsupp,
        supplier,
        nation
   WHERE ps_suppkey = s_suppkey
     AND s_nationkey = n_nationkey
     AND n_name = &&&_B)
ORDER BY value DESC;