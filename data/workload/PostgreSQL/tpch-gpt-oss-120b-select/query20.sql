WITH qualifying_supp AS
  (SELECT ps.ps_suppkey
   FROM partsupp ps
   JOIN part p ON p.p_partkey = ps.ps_partkey
   WHERE p.p_name LIKE 'forest%'
     AND ps.ps_availqty >
       (SELECT 0.5 * SUM(l_quantity)
        FROM lineitem l
        WHERE l.l_partkey = ps.ps_partkey
          AND l.l_suppkey = ps.ps_suppkey
          AND l.l_shipdate >= DATE '1994-01-01'
          AND l.l_shipdate < CAST('1994-01-01' AS DATE) + INTERVAL '1' YEAR))
SELECT s.s_name,
       s.s_address
FROM supplier s
JOIN nation n ON s.s_nationkey = n.n_nationkey
WHERE s.s_suppkey IN
    (SELECT ps_suppkey
     FROM qualifying_supp)
  AND n.n_name = 'CANADA'
ORDER BY s.s_name;