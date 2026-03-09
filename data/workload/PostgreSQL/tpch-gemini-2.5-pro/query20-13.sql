
SELECT DISTINCT s.s_name,
                s.s_address
FROM supplier s
INNER JOIN nation n ON s.s_nationkey = n.n_nationkey
INNER JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey
WHERE n.n_name = 'CANADA'
  AND ps.ps_partkey IN
    (SELECT p_partkey
     FROM part
     WHERE p_name LIKE 'forest%')
  AND ps.ps_availqty >
    (SELECT 0.5 * sum(l_quantity)
     FROM lineitem
     WHERE l_partkey = ps.ps_partkey
       AND l_suppkey = ps.ps_suppkey
       AND l_shipdate >= date '1994-01-01'
       AND l_shipdate < date '1994-01-01' + interval '1' YEAR)
ORDER BY s.s_name;