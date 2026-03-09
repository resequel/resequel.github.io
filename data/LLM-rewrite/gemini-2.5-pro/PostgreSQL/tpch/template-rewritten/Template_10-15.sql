
SELECT p.p_brand,
       p.p_type,
       p.p_size,
       count(DISTINCT ps.ps_suppkey) AS supplier_cnt
FROM part p
JOIN partsupp ps ON p.p_partkey = ps.ps_partkey
JOIN
  (SELECT ps_suppkey
   FROM partsupp
   EXCEPT SELECT s_suppkey
   FROM supplier
   WHERE s_comment LIKE &&&_C) vs ON ps.ps_suppkey = vs.ps_suppkey
WHERE p.p_brand <> &&&_A
  AND p.p_type NOT LIKE &&&_B
  AND p.p_size IN N_III_A
GROUP BY p.p_brand,
         p.p_type,
         p.p_size
ORDER BY supplier_cnt DESC,
         p.p_brand,
         p.p_type,
         p_size;