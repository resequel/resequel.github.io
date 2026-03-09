
SELECT sum(l.l_extendedprice) / 7.0 AS avg_yearly
FROM part p
JOIN lineitem l ON p.p_partkey = l.l_partkey
CROSS JOIN LATERAL
  (SELECT 0.2 * avg(l_quantity) AS threshold
   FROM lineitem l2
   WHERE l2.l_partkey = p.p_partkey) pa
WHERE p.p_brand = 'Brand#23'
  AND p.p_container = 'MED BOX'
  AND l.l_quantity < pa.threshold;