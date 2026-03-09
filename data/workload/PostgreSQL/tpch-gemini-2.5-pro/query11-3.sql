
SELECT ps_partkey,
       sum(ps_supplycost * ps_availqty) AS value
FROM partsupp ps,
     supplier s,
     nation n
WHERE ps.ps_suppkey = s.s_suppkey
  AND s.s_nationkey = n.n_nationkey
  AND n.n_name = 'GERMANY'
GROUP BY ps_partkey
HAVING sum(ps_supplycost * ps_availqty) >
  (SELECT sum(ps2.ps_supplycost * ps2.ps_availqty) * 0.0001
   FROM partsupp ps2
   INNER JOIN supplier s2 ON ps2.ps_suppkey = s2.s_suppkey
   INNER JOIN nation n2 ON s2.s_nationkey = n2.n_nationkey
   WHERE n2.n_name = 'GERMANY')
ORDER BY value DESC;