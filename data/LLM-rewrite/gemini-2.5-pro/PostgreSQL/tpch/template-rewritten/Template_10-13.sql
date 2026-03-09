
SELECT p.p_brand,
       p.p_type,
       p.p_size,
       count(DISTINCT ps.ps_suppkey) AS supplier_cnt
FROM part p
JOIN partsupp ps ON p.p_partkey = ps.ps_partkey
LEFT JOIN supplier s ON ps.ps_suppkey = s.s_suppkey
AND s.s_comment LIKE &&&_C
WHERE p.p_brand <> &&&_A
  AND p.p_type NOT LIKE &&&_B
  AND p.p_size IN N_III_A
  AND s.s_suppkey IS NULL
GROUP BY p.p_brand,
         p.p_type,
         p.p_size
ORDER BY supplier_cnt DESC,
         p.p_brand,
         p.p_type,
         p_size;