WITH thresh AS
  (SELECT sum(ps_supplycost * ps_availqty) * 0.0001 AS val
   FROM partsupp
   JOIN supplier ON ps_suppkey = s_suppkey
   JOIN nation ON s_nationkey = n_nationkey
   WHERE n_name = 'GERMANY'),
     supps AS
  (SELECT s_suppkey
   FROM supplier
   JOIN nation ON s_nationkey = n_nationkey
   WHERE n_name = 'GERMANY')
SELECT ps_partkey,
       sum(ps_supplycost * ps_availqty) AS value
FROM partsupp
JOIN supps ON ps_suppkey = s_suppkey
GROUP BY ps_partkey
HAVING sum(ps_supplycost * ps_availqty) >
  (SELECT val
   FROM thresh)
ORDER BY value DESC;