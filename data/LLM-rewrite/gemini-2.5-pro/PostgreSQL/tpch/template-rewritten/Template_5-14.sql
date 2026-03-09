
SELECT ps_partkey,
       sum(ps_supplycost * ps_availqty) AS value
FROM partsupp
INNER JOIN supplier ON ps_suppkey = s_suppkey
INNER JOIN nation ON s_nationkey = n_nationkey
WHERE n_name = &&&_A
GROUP BY ps_partkey
HAVING sum(ps_supplycost * ps_availqty) >
  (SELECT sum(ps_supplycost * ps_availqty) * ^^^_A
   FROM partsupp
   INNER JOIN supplier ON ps_suppkey = s_suppkey
   INNER JOIN nation ON s_nationkey = n_nationkey
   WHERE n_name = &&&_B)
ORDER BY value DESC;