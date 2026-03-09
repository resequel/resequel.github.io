WITH p AS
  (SELECT p_partkey,
          p_mfgr
   FROM part
   WHERE p_size = ###_A
     AND p_type LIKE &&&_A),
     sr AS
  (SELECT s_suppkey,
          s_acctbal,
          s_name,
          s_address,
          s_phone,
          s_comment,
          n_name
   FROM supplier
   JOIN nation ON s_nationkey = n_nationkey
   JOIN region ON n_regionkey = r_regionkey
   WHERE r_name = &&&_B)
SELECT sr.s_acctbal,
       sr.s_name,
       sr.n_name,
       p.p_partkey,
       p.p_mfgr,
       sr.s_address,
       sr.s_phone,
       sr.s_comment
FROM p
JOIN partsupp ps ON p.p_partkey = ps.ps_partkey
JOIN sr ON ps.ps_suppkey = sr.s_suppkey
WHERE ps.ps_supplycost =
    (SELECT min(ps2.ps_supplycost)
     FROM partsupp ps2
     JOIN sr sr2 ON ps2.ps_suppkey = sr2.s_suppkey
     WHERE ps2.ps_partkey = p.p_partkey)
ORDER BY sr.s_acctbal DESC,
         sr.n_name,
         sr.s_name,
         p.p_partkey
LIMIT ###_B;