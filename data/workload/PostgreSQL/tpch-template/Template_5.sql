SELECT ps_partkey,
       sum(ps_supplycost * ps_availqty) AS value
FROM partsupp,
     supplier,
     nation
WHERE ps_suppkey = s_suppkey
  AND s_nationkey = n_nationkey
  AND n_name = &&&_A
GROUP BY ps_partkey
HAVING sum(ps_supplycost * ps_availqty) >
  (SELECT sum(ps_supplycost * ps_availqty) * ^^^_A
   FROM partsupp,
        supplier,
        nation
   WHERE ps_suppkey = s_suppkey
     AND s_nationkey = n_nationkey
     AND n_name = &&&_B)
ORDER BY value DESC;