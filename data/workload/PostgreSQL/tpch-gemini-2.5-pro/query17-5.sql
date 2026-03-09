WITH p AS
  (SELECT p_partkey
   FROM part
   WHERE p_brand = 'Brand#23'
     AND p_container = 'MED BOX'),
     part_avg AS
  (SELECT l.l_partkey, 0.2 * avg(l.l_quantity) AS threshold
   FROM lineitem l
   JOIN p ON l.l_partkey = p.p_partkey
   GROUP BY l.l_partkey)
SELECT sum(l.l_extendedprice) / 7.0 AS avg_yearly
FROM lineitem l
JOIN p ON l.l_partkey = p.p_partkey
JOIN part_avg pa ON l.l_partkey = pa.l_partkey
WHERE l.l_quantity < pa.threshold;