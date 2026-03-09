
SELECT ps_partkey,
       sum(ps_supplycost * ps_availqty) AS value
FROM partsupp
JOIN supplier ON ps_suppkey = s_suppkey
WHERE s_nationkey IN
    (SELECT n_nationkey
     FROM nation
     WHERE n_name = 'GERMANY')
GROUP BY ps_partkey
HAVING sum(ps_supplycost * ps_availqty) >
  (SELECT sum(ps_supplycost * ps_availqty) * 0.0001
   FROM partsupp
   JOIN supplier ON ps_suppkey = s_suppkey
   WHERE s_nationkey IN
       (SELECT n_nationkey
        FROM nation
        WHERE n_name = 'GERMANY'))
ORDER BY value DESC;