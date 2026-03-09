
SELECT ps_partkey,
       sum(ps_supplycost * ps_availqty) AS value
FROM partsupp
JOIN supplier ON ps_suppkey = s_suppkey
JOIN nation ON s_nationkey = n_nationkey
WHERE n_name = &&&_A
GROUP BY ps_partkey
HAVING sum(ps_supplycost * ps_availqty) >
  (SELECT sum(ps2.ps_supplycost * ps2.ps_availqty) * ^^^_A
   FROM partsupp ps2
   JOIN supplier s2 ON ps2.ps_suppkey = s2.s_suppkey
   JOIN nation n2 ON s2.s_nationkey = n2.n_nationkey
   WHERE n2.n_name = &&&_B)
ORDER BY value DESC;