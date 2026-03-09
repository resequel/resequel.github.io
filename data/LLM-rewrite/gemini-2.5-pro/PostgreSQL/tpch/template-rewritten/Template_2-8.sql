
SELECT sum(l.l_extendedprice) / ^^^_A AS avg_yearly
FROM lineitem l
JOIN
  (SELECT p_partkey
   FROM part
   WHERE p_brand = &&&_A
     AND p_container = &&&_B) p ON l.l_partkey = p.p_partkey
JOIN
  (SELECT l2.l_partkey, ^^^_B * avg(l2.l_quantity) AS threshold
   FROM lineitem l2
   JOIN part p2 ON l2.l_partkey = p2.p_partkey
   WHERE p2.p_brand = &&&_A
     AND p2.p_container = &&&_B
   GROUP BY l2.l_partkey) pa ON l.l_partkey = pa.l_partkey
WHERE l.l_quantity < pa.threshold;