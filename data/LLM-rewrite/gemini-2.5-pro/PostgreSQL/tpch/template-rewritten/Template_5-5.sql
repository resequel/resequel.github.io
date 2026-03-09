WITH thresh AS
  (SELECT sum(ps_supplycost * ps_availqty) * ^^^_A AS val
   FROM partsupp
   JOIN supplier ON ps_suppkey = s_suppkey
   JOIN nation ON s_nationkey = n_nationkey
   WHERE n_name = &&&_B),
     supps AS
  (SELECT s_suppkey
   FROM supplier
   JOIN nation ON s_nationkey = n_nationkey
   WHERE n_name = &&&_A)
SELECT ps_partkey,
       sum(ps_supplycost * ps_availqty) AS value
FROM partsupp
JOIN supps ON ps_suppkey = s_suppkey
CROSS JOIN thresh
GROUP BY ps_partkey,
         thresh.val
HAVING sum(ps_supplycost * ps_availqty) > thresh.val
ORDER BY value DESC;