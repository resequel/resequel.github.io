WITH p AS
  (SELECT p_partkey,
          p_mfgr
   FROM part
   WHERE p_size = 15
     AND p_type LIKE '%BRASS'),
     sr AS
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
     ranked_ps AS
  (SELECT ps.ps_partkey,
          ps.ps_suppkey,
          rank() OVER (PARTITION BY ps.ps_partkey
                       ORDER BY ps.ps_supplycost ASC) AS rnk
   FROM partsupp ps
   JOIN sr ON ps.ps_suppkey = sr.s_suppkey)
SELECT sr.s_acctbal,
       sr.s_name,
       sr.n_name,
       p.p_partkey,
       p.p_mfgr,
       sr.s_address,
       sr.s_phone,
       sr.s_comment
FROM p
JOIN ranked_ps rps ON p.p_partkey = rps.ps_partkey
JOIN sr ON rps.ps_suppkey = sr.s_suppkey
WHERE rps.rnk = 1
ORDER BY sr.s_acctbal DESC,
         sr.n_name,
         sr.s_name,
         p.p_partkey
LIMIT 100;