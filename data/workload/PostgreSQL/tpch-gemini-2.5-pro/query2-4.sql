WITH min_costs AS
  (SELECT ps_partkey,
          min(ps_supplycost) AS min_cost
   FROM partsupp
   JOIN supplier ON ps_suppkey = s_suppkey
   JOIN nation ON s_nationkey = n_nationkey
   JOIN region ON n_regionkey = r_regionkey
   WHERE r_name = 'EUROPE'
   GROUP BY ps_partkey)
SELECT s_acctbal,
       s_name,
       n_name,
       p_partkey,
       p_mfgr,
       s_address,
       s_phone,
       s_comment
FROM part p
JOIN partsupp ps ON p.p_partkey = ps.ps_partkey
JOIN supplier s ON ps.ps_suppkey = s.s_suppkey
JOIN nation n ON s.s_nationkey = n.n_nationkey
JOIN region r ON n.n_regionkey = r.r_regionkey
JOIN min_costs mc ON ps.ps_partkey = mc.ps_partkey
AND ps.ps_supplycost = mc.min_cost
WHERE p.p_size = 15
  AND p.p_type LIKE '%BRASS'
  AND r.r_name = 'EUROPE'
ORDER BY s_acctbal DESC,
         n_name,
         s_name,
         p_partkey
LIMIT 100;