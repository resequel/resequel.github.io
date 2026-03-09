
SELECT ps_partkey,
       sum(ps_supplycost * ps_availqty) AS value
FROM partsupp
JOIN supplier ON ps_suppkey = s_suppkey
WHERE s_nationkey IN
    (SELECT n_nationkey
     FROM nation
     WHERE n_name = &&&_A)
GROUP BY ps_partkey
HAVING sum(ps_supplycost * ps_availqty) >
  (SELECT sum(ps_supplycost * ps_availqty) * ^^^_A
   FROM partsupp
   JOIN supplier ON ps_suppkey = s_suppkey
   WHERE s_nationkey IN
       (SELECT n_nationkey
        FROM nation
        WHERE n_name = &&&_B))
ORDER BY value DESC;