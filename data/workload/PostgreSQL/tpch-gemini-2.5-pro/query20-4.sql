WITH l_agg AS
  (SELECT l_partkey,
          l_suppkey, 0.5 * sum(l_quantity) AS threshold
   FROM lineitem
   WHERE l_shipdate >= date '1994-01-01'
     AND l_shipdate < date '1994-01-01' + interval '1' YEAR
   GROUP BY l_partkey,
            l_suppkey)
SELECT s.s_name,
       s.s_address
FROM supplier s
JOIN nation n ON s.s_nationkey = n.n_nationkey
WHERE n.n_name = 'CANADA'
  AND EXISTS
    (SELECT 1
     FROM partsupp ps
     JOIN part p ON ps.ps_partkey = p.p_partkey
     JOIN l_agg l ON ps.ps_partkey = l.l_partkey
     AND ps.ps_suppkey = l.l_suppkey
     WHERE ps.ps_suppkey = s.s_suppkey
       AND p.p_name LIKE 'forest%'
       AND ps.ps_availqty > l.threshold)
ORDER BY s.s_name;