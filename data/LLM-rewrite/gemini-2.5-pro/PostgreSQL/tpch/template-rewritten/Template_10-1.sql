WITH p AS
  (SELECT p_partkey,
          p_brand,
          p_type,
          p_size
   FROM part
   WHERE p_brand <> &&&_A
     AND p_type NOT LIKE &&&_B
     AND p_size IN N_III_A),
     bad_s AS
  (SELECT s_suppkey
   FROM supplier
   WHERE s_comment LIKE &&&_C),
     dist AS
  (SELECT DISTINCT p.p_brand,
                   p.p_type,
                   p.p_size,
                   ps.ps_suppkey
   FROM p
   JOIN partsupp ps ON p.p_partkey = ps.ps_partkey
   WHERE NOT EXISTS
       (SELECT 1
        FROM bad_s
        WHERE bad_s.s_suppkey = ps.ps_suppkey))
SELECT p_brand,
       p_type,
       p_size,
       count(ps_suppkey) AS supplier_cnt
FROM dist
GROUP BY p_brand,
         p_type,
         p_size
ORDER BY supplier_cnt DESC,
         p_brand,
         p_type,
         p_size;