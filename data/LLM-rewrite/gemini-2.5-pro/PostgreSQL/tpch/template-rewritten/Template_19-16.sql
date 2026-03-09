
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
WHERE r_name = &&&_B
  AND p_size = ###_A
  AND p_type LIKE &&&_A
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
     WHERE r_name = &&&_C
       AND n_regionkey = r_regionkey
       AND s_nationkey = n_nationkey
       AND s_suppkey = ps_suppkey
       AND p_partkey = ps_partkey)
ORDER BY s_acctbal DESC,
         n_name,
         s_name,
         p_partkey
LIMIT ###_B;