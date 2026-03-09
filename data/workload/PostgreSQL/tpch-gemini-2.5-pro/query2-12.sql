
SELECT s.s_acctbal,
       s.s_name,
       n.n_name,
       p.p_partkey,
       p.p_mfgr,
       s.s_address,
       s.s_phone,
       s.s_comment
FROM
  (SELECT p_partkey,
          p_mfgr
   FROM part
   WHERE p_size = 15
     AND p_type LIKE '%BRASS') p
JOIN partsupp ps ON p.p_partkey = ps.ps_partkey
JOIN
  (SELECT s_suppkey,
          s_acctbal,
          s_name,
          s_address,
          s_phone,
          s_comment,
          s_nationkey
   FROM supplier) s ON ps.ps_suppkey = s.s_suppkey
JOIN
  (SELECT n_nationkey,
          n_name
   FROM nation
   JOIN region ON n_regionkey = r_regionkey
   WHERE r_name = 'EUROPE') n ON s.s_nationkey = n.n_nationkey
JOIN
  (SELECT ps2.ps_partkey,
          min(ps2.ps_supplycost) AS min_cost
   FROM partsupp ps2
   JOIN supplier s2 ON ps2.ps_suppkey = s2.s_suppkey
   JOIN nation n2 ON s2.s_nationkey = n2.n_nationkey
   JOIN region r2 ON n2.n_regionkey = r2.r_regionkey
   WHERE r2.r_name = 'EUROPE'
   GROUP BY ps2.ps_partkey) min_ps ON ps.ps_partkey = min_ps.ps_partkey
AND ps.ps_supplycost = min_ps.min_cost
ORDER BY s.s_acctbal DESC,
         n.n_name,
         s.s_name,
         p.p_partkey
LIMIT 100;