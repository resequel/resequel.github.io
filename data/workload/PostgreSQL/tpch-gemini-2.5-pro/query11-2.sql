WITH calc_ps AS
  (SELECT ps_partkey,
          ps_suppkey,
          ps_supplycost * ps_availqty AS val
   FROM partsupp),
     thresh AS
  (SELECT sum(val) * 0.0001 AS t_val
   FROM calc_ps
   JOIN supplier ON ps_suppkey = s_suppkey
   JOIN nation ON s_nationkey = n_nationkey
   WHERE n_name = 'GERMANY')
SELECT ps_partkey,
       sum(val) AS value
FROM calc_ps
JOIN supplier ON ps_suppkey = s_suppkey
JOIN nation ON s_nationkey = n_nationkey
WHERE n_name = 'GERMANY'
GROUP BY ps_partkey
HAVING sum(val) >
  (SELECT t_val
   FROM thresh)
ORDER BY value DESC;