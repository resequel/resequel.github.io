WITH p AS
  (SELECT p_partkey
   FROM part
   WHERE p_brand = &&&_A
     AND p_container = &&&_B),
     part_avg AS
  (SELECT l.l_partkey, ^^^_B * avg(l.l_quantity) AS threshold
   FROM lineitem l
   JOIN p ON l.l_partkey = p.p_partkey
   GROUP BY l.l_partkey)
SELECT sum(l.l_extendedprice) / ^^^_A AS avg_yearly
FROM lineitem l
JOIN p ON l.l_partkey = p.p_partkey
JOIN part_avg pa ON l.l_partkey = pa.l_partkey
WHERE l.l_quantity < pa.threshold;