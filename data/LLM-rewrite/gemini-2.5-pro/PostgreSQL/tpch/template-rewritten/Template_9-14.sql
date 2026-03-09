
SELECT s.s_name,
       s.s_address
FROM supplier s
INNER JOIN nation n ON s.s_nationkey = n.n_nationkey
WHERE n.n_name = &&&_E
  AND EXISTS
    (SELECT 1
     FROM partsupp ps
     INNER JOIN part p ON ps.ps_partkey = p.p_partkey
     WHERE ps.ps_suppkey = s.s_suppkey
       AND p.p_name LIKE &&&_A
       AND ps.ps_availqty >
         (SELECT ^^^_A * sum(l_quantity)
          FROM lineitem l
          WHERE l.l_partkey = ps.ps_partkey
            AND l.l_suppkey = ps.ps_suppkey
            AND l.l_shipdate >= date &&&_B
            AND l.l_shipdate < date &&&_C + interval &&&_D YEAR))
ORDER BY s.s_name;