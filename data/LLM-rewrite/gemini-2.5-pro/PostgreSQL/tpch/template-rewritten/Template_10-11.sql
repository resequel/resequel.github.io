
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
   WHERE p.p_brand <> &&&_A
     AND p.p_type NOT LIKE &&&_B
     AND p.p_size IN N_III_A
     AND NOT EXISTS
       (SELECT 1
        FROM supplier s
        WHERE s.s_suppkey = ps.ps_suppkey
          AND s.s_comment LIKE &&&_C)
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