
SELECT s_acctbal,
       s_name,
       n_name,
       p_partkey,
       p_mfgr,
       s_address,
       s_phone,
       s_comment
FROM region
INNER JOIN nation ON r_regionkey = n_regionkey
INNER JOIN supplier ON n_nationkey = s_nationkey
INNER JOIN partsupp ON s_suppkey = ps_suppkey
INNER JOIN part ON ps_partkey = p_partkey
WHERE p_size = ###_A
  AND p_type LIKE &&&_A
  AND r_name = &&&_B
  AND ps_supplycost =
    (SELECT min(ps_supplycost)
     FROM partsupp
     INNER JOIN supplier ON ps_suppkey = s_suppkey
     INNER JOIN nation ON s_nationkey = n_nationkey
     INNER JOIN region ON n_regionkey = r_regionkey
     WHERE p_partkey = ps_partkey
       AND r_name = &&&_C)
ORDER BY s_acctbal DESC,
         n_name,
         s_name,
         p_partkey
LIMIT ###_B;