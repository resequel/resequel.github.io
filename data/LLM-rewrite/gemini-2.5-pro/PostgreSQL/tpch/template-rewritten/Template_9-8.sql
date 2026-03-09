
SELECT s.s_name,
       s.s_address
FROM supplier s
JOIN nation n ON s.s_nationkey = n.n_nationkey
WHERE n.n_name = &&&_E
  AND EXISTS
    (SELECT 1
     FROM partsupp ps
     WHERE ps.ps_suppkey = s.s_suppkey
       AND EXISTS
         (SELECT 1
          FROM part p
          WHERE p.p_partkey = ps.ps_partkey
            AND p.p_name LIKE &&&_A)
       AND ps.ps_availqty >
         (SELECT ^^^_A * sum(l.l_quantity)
          FROM lineitem l
          WHERE l.l_partkey = ps.ps_partkey
            AND l.l_suppkey = ps.ps_suppkey
            AND l.l_shipdate >= date &&&_B
            AND l.l_shipdate < date &&&_C + interval &&&_D YEAR))
ORDER BY s.s_name;