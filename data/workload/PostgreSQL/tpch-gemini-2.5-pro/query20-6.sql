WITH filtered_supp AS
  (SELECT s_suppkey,
          s_name,
          s_address
   FROM supplier
   JOIN nation ON s_nationkey = n_nationkey
   WHERE n_name = 'CANADA')
SELECT s.s_name,
       s.s_address
FROM filtered_supp s
WHERE EXISTS
    (SELECT 1
     FROM partsupp ps
     JOIN part p ON ps.ps_partkey = p.p_partkey
     JOIN
       (SELECT l_partkey,
               l_suppkey, 0.5 * sum(l_quantity) AS threshold
        FROM lineitem
        WHERE l_shipdate >= date '1994-01-01'
          AND l_shipdate < date '1994-01-01' + interval '1' YEAR
        GROUP BY l_partkey,
                 l_suppkey) l ON ps.ps_partkey = l.l_partkey
     AND ps.ps_suppkey = l.l_suppkey
     WHERE ps.ps_suppkey = s.s_suppkey
       AND p.p_name LIKE 'forest%'
       AND ps.ps_availqty > l.threshold)
ORDER BY s.s_name;