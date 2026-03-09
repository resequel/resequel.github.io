WITH n_a AS
  (SELECT n_nationkey
   FROM nation
   WHERE n_name = &&&_A),
     n_b AS
  (SELECT n_nationkey
   FROM nation
   WHERE n_name = &&&_B)
SELECT ps_partkey,
       sum(ps_supplycost * ps_availqty) AS value
FROM partsupp
JOIN supplier ON ps_suppkey = s_suppkey
JOIN n_a ON s_nationkey = n_a.n_nationkey
GROUP BY ps_partkey
HAVING sum(ps_supplycost * ps_availqty) >
  (SELECT sum(ps_supplycost * ps_availqty) * ^^^_A
   FROM partsupp
   JOIN supplier ON ps_suppkey = s_suppkey
   JOIN n_b ON s_nationkey = n_b.n_nationkey)
ORDER BY value DESC;