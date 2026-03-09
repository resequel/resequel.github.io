
SELECT p_brand,
       p_type,
       p_size,
       count(DISTINCT ps_suppkey) AS supplier_cnt
FROM
  (SELECT p_partkey,
          p_brand,
          p_type,
          p_size
   FROM part
   WHERE p_brand <> &&&_A
     AND p_type NOT LIKE &&&_B
     AND p_size IN N_III_A) p
JOIN partsupp ps ON p.p_partkey = ps.ps_partkey
LEFT JOIN
  (SELECT s_suppkey
   FROM supplier
   WHERE s_comment LIKE &&&_C) s ON ps.ps_suppkey = s.s_suppkey
WHERE s.s_suppkey IS NULL
GROUP BY p_brand,
         p_type,
         p_size
ORDER BY supplier_cnt DESC,
         p_brand,
         p_type,
         p_size;