
SELECT s_name,
       s_address
FROM supplier s
WHERE EXISTS
    (SELECT 1
     FROM nation n
     WHERE s.s_nationkey = n.n_nationkey
       AND n.n_name = 'CANADA')
  AND EXISTS
    (SELECT 1
     FROM partsupp ps
     WHERE ps.ps_suppkey = s.s_suppkey
       AND EXISTS
         (SELECT 1
          FROM part p
          WHERE p.p_partkey = ps.ps_partkey
            AND p.p_name LIKE 'forest%')
       AND ps.ps_availqty >
         (SELECT 0.5 * sum(l_quantity)
          FROM lineitem l
          WHERE l.l_partkey = ps.ps_partkey
            AND l.l_suppkey = ps.ps_suppkey
            AND l.l_shipdate >= date '1994-01-01'
            AND l.l_shipdate < date '1994-01-01' + interval '1' YEAR))
ORDER BY s_name;