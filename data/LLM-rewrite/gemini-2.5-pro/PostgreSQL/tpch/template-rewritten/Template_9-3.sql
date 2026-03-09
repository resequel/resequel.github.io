
SELECT s.s_name,
       s.s_address
FROM supplier s
JOIN nation n ON s.s_nationkey = n.n_nationkey
WHERE n.n_name = &&&_E
  AND EXISTS
    (SELECT 1
     FROM partsupp ps
     JOIN
       (SELECT l.l_partkey,
               l.l_suppkey, ^^^_A * sum(l.l_quantity) AS threshold
        FROM lineitem l
        JOIN part p ON l.l_partkey = p.p_partkey
        WHERE p.p_name LIKE &&&_A
          AND l.l_shipdate >= date &&&_B
          AND l.l_shipdate < date &&&_C + interval &&&_D YEAR
        GROUP BY l.l_partkey,
                 l.l_suppkey) agg ON ps.ps_partkey = agg.l_partkey
     AND ps.ps_suppkey = agg.l_suppkey
     WHERE ps.ps_suppkey = s.s_suppkey
       AND ps.ps_availqty > agg.threshold)
ORDER BY s.s_name;