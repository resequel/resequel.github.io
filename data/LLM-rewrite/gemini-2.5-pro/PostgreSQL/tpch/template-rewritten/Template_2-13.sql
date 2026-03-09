
SELECT sum(l.l_extendedprice) / ^^^_A AS avg_yearly
FROM part p
JOIN lineitem l ON p.p_partkey = l.l_partkey
CROSS JOIN LATERAL
  (SELECT ^^^_B * avg(l_quantity) AS threshold
   FROM lineitem l2
   WHERE l2.l_partkey = p.p_partkey) pa
WHERE p.p_brand = &&&_A
  AND p.p_container = &&&_B
  AND l.l_quantity < pa.threshold;