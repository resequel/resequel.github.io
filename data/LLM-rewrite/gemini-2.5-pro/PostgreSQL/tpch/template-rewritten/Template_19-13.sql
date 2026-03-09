
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
WHERE p_partkey = ps_partkey
  AND s_suppkey = ps_suppkey
  AND s_nationkey = n_nationkey
  AND n_regionkey = r_regionkey
  AND p_size = ###_A
  AND p_type LIKE &&&_A
  AND r_name = &&&_B
  AND ps_supplycost =
    (SELECT min(ps_supplycost)
     FROM partsupp
     INNER JOIN supplier ON s_suppkey = ps_suppkey
     INNER JOIN nation ON s_nationkey = n_nationkey
     INNER JOIN region ON n_regionkey = r_regionkey
     WHERE p_partkey = ps_partkey
       AND r_name = &&&_C)
ORDER BY s_acctbal DESC,
         n_name,
         s_name,
         p_partkey
LIMIT ###_B;