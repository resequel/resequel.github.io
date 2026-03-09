
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
   WHERE p_brand <> &&&_A
     AND p_type NOT LIKE &&&_B
     AND p_size IN N_III_A) p,
     partsupp ps
WHERE p.p_partkey = ps.ps_partkey
  AND ps.ps_suppkey NOT IN
    (SELECT s_suppkey
     FROM supplier
     WHERE s_comment LIKE &&&_C)
GROUP BY p.p_brand,
         p.p_type,
         p.p_size
ORDER BY supplier_cnt DESC,
         p.p_brand,
         p.p_type,
         p_size;