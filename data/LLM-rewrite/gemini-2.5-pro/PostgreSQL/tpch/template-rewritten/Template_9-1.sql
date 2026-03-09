WITH p AS
  (SELECT p_partkey
   FROM part
   WHERE p_name LIKE &&&_A),
     l_agg AS
  (SELECT l_partkey,
          l_suppkey, ^^^_A * sum(l_quantity) AS threshold
   FROM lineitem
   JOIN p ON l_partkey = p.p_partkey
   WHERE l_shipdate >= date &&&_B
     AND l_shipdate < date &&&_C + interval &&&_D YEAR
   GROUP BY l_partkey,
            l_suppkey)
SELECT s.s_name,
       s.s_address
FROM supplier s
JOIN nation n ON s.s_nationkey = n.n_nationkey
WHERE n.n_name = &&&_E
  AND EXISTS
    (SELECT 1
     FROM partsupp ps
     JOIN l_agg l ON ps.ps_partkey = l.l_partkey
     AND ps.ps_suppkey = l.l_suppkey
     WHERE ps.ps_suppkey = s.s_suppkey
       AND ps.ps_availqty > l.threshold)
ORDER BY s.s_name;