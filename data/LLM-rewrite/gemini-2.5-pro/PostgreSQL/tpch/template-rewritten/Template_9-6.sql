
SELECT DISTINCT s.s_name,
                s.s_address
FROM supplier s
JOIN nation n ON s.s_nationkey = n.n_nationkey
JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey
JOIN part p ON ps.ps_partkey = p.p_partkey
JOIN
  (SELECT l_partkey,
          l_suppkey, ^^^_A * sum(l_quantity) AS threshold
   FROM lineitem
   WHERE l_shipdate >= date &&&_B
     AND l_shipdate < date &&&_C + interval &&&_D YEAR
   GROUP BY l_partkey,
            l_suppkey) l_agg ON ps.ps_partkey = l_agg.l_partkey
AND ps.ps_suppkey = l_agg.l_suppkey
WHERE n.n_name = &&&_E
  AND p.p_name LIKE &&&_A
  AND ps.ps_availqty > l_agg.threshold
ORDER BY s.s_name;