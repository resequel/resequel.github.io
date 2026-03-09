
SELECT DISTINCT s.s_name,
                s.s_address
FROM supplier s
INNER JOIN nation n ON s.s_nationkey = n.n_nationkey
INNER JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey
WHERE n.n_name = &&&_E
  AND ps.ps_partkey IN
    (SELECT p_partkey
     FROM part
     WHERE p_name LIKE &&&_A)
  AND ps.ps_availqty >
    (SELECT ^^^_A * sum(l_quantity)
     FROM lineitem
     WHERE l_partkey = ps.ps_partkey
       AND l_suppkey = ps.ps_suppkey
       AND l_shipdate >= date &&&_B
       AND l_shipdate < date &&&_C + interval &&&_D YEAR)
ORDER BY s.s_name;