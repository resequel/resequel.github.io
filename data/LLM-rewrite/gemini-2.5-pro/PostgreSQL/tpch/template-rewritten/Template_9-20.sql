
SELECT s_name,
       s_address
FROM supplier,
     nation
WHERE s_suppkey IN
    (SELECT ps_suppkey
     FROM partsupp
     WHERE ps_partkey IN
         (SELECT p_partkey
          FROM part
          WHERE p_name LIKE &&&_A)
       AND ps_availqty >
         (SELECT ^^^_A * sum(l_quantity)
          FROM lineitem
          WHERE l_partkey = ps_partkey
            AND l_suppkey = ps_suppkey
            AND l_shipdate >= date &&&_B
            AND l_shipdate < date &&&_C + interval &&&_D YEAR))
  AND s_nationkey = n_nationkey
  AND n_name = &&&_E
ORDER BY s_name;