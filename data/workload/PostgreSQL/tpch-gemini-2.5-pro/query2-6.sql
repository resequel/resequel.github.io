WITH sr AS
  (SELECT s.s_suppkey,
          s.s_acctbal,
          s.s_name,
          s.s_address,
          s.s_phone,
          s.s_comment,
          n.n_name
   FROM supplier s
   JOIN nation n ON s.s_nationkey = n.n_nationkey
   JOIN region r ON n.n_regionkey = r.r_regionkey
   WHERE r.r_name = 'EUROPE'),
     p AS
  (SELECT p_partkey,
          p_mfgr
   FROM part
   WHERE p_size = 15
     AND p_type LIKE '%BRASS')
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
JOIN
  (SELECT ps2.ps_partkey,
          min(ps2.ps_supplycost) AS min_cost
   FROM partsupp ps2
   JOIN sr sr2 ON ps2.ps_suppkey = sr2.s_suppkey
   GROUP BY ps2.ps_partkey) min_ps ON ps.ps_partkey = min_ps.ps_partkey
AND ps.ps_supplycost = min_ps.min_cost
ORDER BY sr.s_acctbal DESC,
         sr.n_name,
         sr.s_name,
         p.p_partkey
LIMIT 100;