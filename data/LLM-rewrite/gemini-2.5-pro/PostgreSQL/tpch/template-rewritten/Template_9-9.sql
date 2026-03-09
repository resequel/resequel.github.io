
SELECT s.s_name,
       s.s_address
FROM supplier s
JOIN nation n ON s.s_nationkey = n.n_nationkey
WHERE n.n_name = &&&_E
  AND s.s_suppkey IN
    (SELECT ps.ps_suppkey
     FROM partsupp ps
     JOIN part p ON ps.ps_partkey = p.p_partkey
     WHERE p.p_name LIKE &&&_A
       AND ps.ps_availqty >
         (SELECT ^^^_A * sum(l_quantity)
          FROM lineitem l
          WHERE l.l_partkey = ps.ps_partkey
            AND l.l_suppkey = ps.ps_suppkey
            AND l.l_shipdate >= date &&&_B
            AND l.l_shipdate < date &&&_C + interval &&&_D YEAR))
ORDER BY s.s_name;