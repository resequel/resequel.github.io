
SELECT p_brand,
       p_type,
       p_size,
       count(DISTINCT ps_suppkey) AS supplier_cnt
FROM partsupp
INNER JOIN part ON p_partkey = ps_partkey
WHERE p_brand <> &&&_A
  AND p_type NOT LIKE &&&_B
  AND p_size IN N_III_A
  AND ps_suppkey NOT IN
    (SELECT s_suppkey
     FROM supplier
     WHERE s_comment LIKE &&&_C)
GROUP BY p_brand,
         p_type,
         p_size
ORDER BY supplier_cnt DESC,
         p_brand,
         p_type,
         p_size;