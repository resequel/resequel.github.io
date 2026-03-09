
SELECT s_acctbal,
       s_name,
       n_name,
       p_partkey,
       p_mfgr,
       s_address,
       s_phone,
       s_comment
FROM part,
     supplier,
     partsupp,
     nation,
     region
WHERE r_name = &&&_B
  AND p_type LIKE &&&_A
  AND p_size = ###_A
  AND p_partkey = ps_partkey
  AND s_suppkey = ps_suppkey
  AND s_nationkey = n_nationkey
  AND n_regionkey = r_regionkey
  AND ps_supplycost =
    (SELECT min(ps_supplycost)
     FROM partsupp,
          supplier,
          nation,
          region
     WHERE r_name = &&&_C
       AND p_partkey = ps_partkey
       AND s_suppkey = ps_suppkey
       AND s_nationkey = n_nationkey
       AND n_regionkey = r_regionkey)
ORDER BY s_acctbal DESC,
         n_name,
         s_name,
         p_partkey
LIMIT ###_B;