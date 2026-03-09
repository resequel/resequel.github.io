
SELECT ps.ps_partkey,
       sum(ps.ps_supplycost * ps.ps_availqty) AS value
FROM partsupp ps
WHERE EXISTS
    (SELECT 1
     FROM supplier s
     JOIN nation n ON s.s_nationkey = n.n_nationkey
     WHERE s.s_suppkey = ps.ps_suppkey
       AND n.n_name = 'GERMANY')
GROUP BY ps.ps_partkey
HAVING sum(ps.ps_supplycost * ps.ps_availqty) >
  (SELECT sum(ps2.ps_supplycost * ps2.ps_availqty) * 0.0001
   FROM partsupp ps2
   WHERE EXISTS
       (SELECT 1
        FROM supplier s2
        JOIN nation n2 ON s2.s_nationkey = n2.n_nationkey
        WHERE s2.s_suppkey = ps2.ps_suppkey
          AND n2.n_name = 'GERMANY'))
ORDER BY value DESC;