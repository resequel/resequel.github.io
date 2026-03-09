
SELECT p.p_brand,
       p.p_type,
       p.p_size,
       count(DISTINCT ps.ps_suppkey) AS supplier_cnt
FROM
  (SELECT p_partkey,
          p_brand,
          p_type,
          p_size
   FROM part
   WHERE p_brand <> 'Brand#45'
     AND p_type NOT LIKE 'MEDIUM POLISHED%'
     AND p_size IN (49,
                 14,
                 23,
                 45,
                 19,
                 3,
                 36,
                 9)) p
JOIN partsupp ps ON p.p_partkey = ps.ps_partkey
WHERE ps.ps_suppkey NOT IN
    (SELECT s_suppkey
     FROM supplier
     WHERE s_comment LIKE '%Customer%Complaints%')
GROUP BY p.p_brand,
         p.p_type,
         p.p_size
ORDER BY supplier_cnt DESC,
         p.p_brand,
         p.p_type,
         p_size;