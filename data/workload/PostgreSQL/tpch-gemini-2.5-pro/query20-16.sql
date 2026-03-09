
SELECT DISTINCT s.s_name,
                s.s_address
FROM supplier s
JOIN nation n ON s.s_nationkey = n.n_nationkey
JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey
JOIN part p ON ps.ps_partkey = p.p_partkey
JOIN
  (SELECT l_partkey,
          l_suppkey, 0.5 * sum(l_quantity) AS threshold
   FROM lineitem
   WHERE l_shipdate >= date '1994-01-01'
     AND l_shipdate < date '1994-01-01' + interval '1' YEAR
   GROUP BY l_partkey,
            l_suppkey) l_agg ON ps.ps_partkey = l_agg.l_partkey
AND ps.ps_suppkey = l_agg.l_suppkey
WHERE n.n_name = 'CANADA'
  AND p.p_name LIKE 'forest%'
  AND ps.ps_availqty > l_agg.threshold
ORDER BY s.s_name;