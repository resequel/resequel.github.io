
SELECT DISTINCT s.s_name,
                s.s_address
FROM supplier s
JOIN nation n ON s.s_nationkey = n.n_nationkey
JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey
JOIN
  (SELECT l.l_partkey,
          l.l_suppkey, 0.5 * sum(l.l_quantity) AS threshold
   FROM lineitem l
   JOIN part p ON l.l_partkey = p.p_partkey
   WHERE p.p_name LIKE 'forest%'
     AND l.l_shipdate >= date '1994-01-01'
     AND l.l_shipdate < date '1994-01-01' + interval '1' YEAR
   GROUP BY l.l_partkey,
            l.l_suppkey) agg ON ps.ps_partkey = agg.l_partkey
AND ps.ps_suppkey = agg.l_suppkey
WHERE n.n_name = 'CANADA'
  AND ps.ps_availqty > agg.threshold
ORDER BY s.s_name;