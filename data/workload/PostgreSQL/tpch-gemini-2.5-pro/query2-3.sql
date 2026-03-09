
SELECT s_acctbal,
       s_name,
       n_name,
       p_partkey,
       p_mfgr,
       s_address,
       s_phone,
       s_comment
FROM region,
     nation,
     supplier,
     partsupp,
     part
WHERE r_name = 'EUROPE'
  AND p_size = 15
  AND p_type LIKE '%BRASS'
  AND n_regionkey = r_regionkey
  AND s_nationkey = n_nationkey
  AND s_suppkey = ps_suppkey
  AND p_partkey = ps_partkey
  AND ps_supplycost =
    (SELECT min(ps_supplycost)
     FROM region,
          nation,
          supplier,
          partsupp
     WHERE r_name = 'EUROPE'
       AND n_regionkey = r_regionkey
       AND s_nationkey = n_nationkey
       AND s_suppkey = ps_suppkey
       AND p_partkey = ps_partkey)
ORDER BY s_acctbal DESC,
         n_name,
         s_name,
         p_partkey
LIMIT 100;