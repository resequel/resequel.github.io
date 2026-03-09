WITH p AS
  (SELECT p_partkey
   FROM part
   WHERE p_brand = 'Brand#23'
     AND p_container = 'MED BOX')
SELECT sum(l.l_extendedprice) / 7.0 AS avg_yearly
FROM p
JOIN lineitem l ON p.p_partkey = l.l_partkey
CROSS JOIN LATERAL
  (SELECT 0.2 * avg(l2.l_quantity) AS threshold
   FROM lineitem l2
   WHERE l2.l_partkey = p.p_partkey) pa
WHERE l.l_quantity < pa.threshold;