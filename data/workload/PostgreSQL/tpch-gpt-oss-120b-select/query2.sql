WITH filtered_region AS
  (SELECT r_regionkey
   FROM region
   WHERE r_name = 'EUROPE'),
     filtered_nation AS
  (SELECT n_nationkey,
          n_name,
          n_regionkey
   FROM nation
   WHERE n_regionkey IN
       (SELECT r_regionkey
        FROM filtered_region)),
     min_cost AS
  (SELECT ps.ps_partkey,
          MIN(ps.ps_supplycost) AS min_supplycost
   FROM partsupp ps
   JOIN supplier s ON s.s_suppkey = ps.ps_suppkey
   JOIN filtered_nation n ON s.s_nationkey = n.n_nationkey
   GROUP BY ps.ps_partkey)
SELECT s.s_acctbal,
       s.s_name,
       n.n_name,
       p.p_partkey,
       p.p_mfgr,
       s.s_address,
       s.s_phone,
       s.s_comment
FROM part p
JOIN partsupp ps ON p.p_partkey = ps.ps_partkey
JOIN supplier s ON s.s_suppkey = ps.ps_suppkey
JOIN filtered_nation n ON s.s_nationkey = n.n_nationkey
JOIN filtered_region r ON n.n_regionkey = r.r_regionkey
JOIN min_cost mc ON mc.ps_partkey = p.p_partkey
WHERE p.p_size = 15
  AND p.p_type LIKE '%BRASS'
  AND ps.ps_supplycost = mc.min_supplycost
ORDER BY s.s_acctbal DESC,
         n.n_name,
         s.s_name,
         p.p_partkey
LIMIT 100;