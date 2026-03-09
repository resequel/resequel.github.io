WITH thresh AS
  (SELECT sum(ps_supplycost * ps_availqty) * ^^^_A AS val
   FROM partsupp
   JOIN supplier ON ps_suppkey = s_suppkey
   JOIN nation ON s_nationkey = n_nationkey
   WHERE n_name = &&&_B)
SELECT ps_partkey,
       sum(ps_supplycost * ps_availqty) AS value
FROM partsupp
WHERE ps_suppkey IN
    (SELECT s_suppkey
     FROM supplier
     JOIN nation ON s_nationkey = n_nationkey
     WHERE n_name = &&&_A)
GROUP BY ps_partkey
HAVING sum(ps_supplycost * ps_availqty) >
  (SELECT val
   FROM thresh)
ORDER BY value DESC;