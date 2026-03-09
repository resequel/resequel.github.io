
SELECT s.s_name,
       s.s_address
FROM supplier s
INNER JOIN nation n ON s.s_nationkey = n.n_nationkey
WHERE n.n_name = 'CANADA'
  AND EXISTS
    (SELECT 1
     FROM partsupp ps
     CROSS JOIN LATERAL
       (SELECT 0.5 * sum(l.l_quantity) AS threshold
        FROM lineitem l
        WHERE l.l_partkey = ps.ps_partkey
          AND l.l_suppkey = ps.ps_suppkey
          AND l.l_shipdate >= date '1994-01-01'
          AND l.l_shipdate < date '1994-01-01' + interval '1' YEAR) agg
     WHERE ps.ps_suppkey = s.s_suppkey
       AND ps.ps_availqty > agg.threshold
       AND EXISTS
         (SELECT 1
          FROM part p
          WHERE p.p_partkey = ps.ps_partkey
            AND p.p_name LIKE 'forest%'))
ORDER BY s.s_name;