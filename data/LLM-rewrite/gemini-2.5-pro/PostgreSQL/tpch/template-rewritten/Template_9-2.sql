WITH n AS
  (SELECT n_nationkey
   FROM nation
   WHERE n_name = &&&_E),
     p AS
  (SELECT p_partkey
   FROM part
   WHERE p_name LIKE &&&_A),
     l_agg AS
  (SELECT l_partkey,
          l_suppkey, ^^^_A * sum(l_quantity) AS threshold
   FROM lineitem
   JOIN p ON l_partkey = p.p_partkey
   WHERE l_shipdate >= date &&&_B
     AND l_shipdate < date &&&_C + interval &&&_D YEAR
   GROUP BY l_partkey,
            l_suppkey)
SELECT DISTINCT s.s_name,
                s.s_address
FROM supplier s
JOIN n ON s.s_nationkey = n.n_nationkey
JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey
JOIN l_agg l ON ps.ps_partkey = l.l_partkey
AND ps.ps_suppkey = l.l_suppkey
WHERE ps.ps_availqty > l.threshold
ORDER BY s.s_name;