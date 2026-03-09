
SELECT p_brand,
       p_type,
       p_size,
       count(ps_suppkey) AS supplier_cnt
FROM
  (SELECT p.p_brand,
          p.p_type,
          p.p_size,
          ps.ps_suppkey
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
     AND ps.ps_suppkey NOT IN
       (SELECT s_suppkey
        FROM supplier
        WHERE s_comment LIKE '%Customer%Complaints%')
   GROUP BY p.p_brand,
            p.p_type,
            p.p_size,
            ps.ps_suppkey) AS grouped
GROUP BY p_brand,
         p_type,
         p_size
ORDER BY supplier_cnt DESC,
         p_brand,
         p_type,
         p_size;