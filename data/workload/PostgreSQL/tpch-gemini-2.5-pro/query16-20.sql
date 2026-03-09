
SELECT p.p_brand,
       p.p_type,
       p.p_size,
       count(DISTINCT ps.ps_suppkey) AS supplier_cnt
FROM part p
JOIN partsupp ps ON p.p_partkey = ps.ps_partkey
WHERE p.p_brand <> 'Brand#45'
  AND p.p_type NOT LIKE 'MEDIUM POLISHED%'
  AND p.p_size IN (49,
                 14,
                 23,
                 45,
                 19,
                 3,
                 36,
                 9)
  AND NOT EXISTS
    (SELECT 1
     FROM supplier s
     WHERE s.s_suppkey = ps.ps_suppkey
       AND s.s_comment LIKE '%Customer%Complaints%')
GROUP BY p.p_brand,
         p.p_type,
         p.p_size
ORDER BY supplier_cnt DESC,
         p.p_brand,
         p.p_type,
         p_size;