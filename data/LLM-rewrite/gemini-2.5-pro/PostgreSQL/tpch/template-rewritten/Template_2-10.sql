
SELECT sum(l.l_extendedprice) / ^^^_A AS avg_yearly
FROM lineitem l
JOIN part p ON l.l_partkey = p.p_partkey
JOIN
  (SELECT l_partkey, ^^^_B * avg(l_quantity) AS threshold
   FROM lineitem
   GROUP BY l_partkey) pa ON l.l_partkey = pa.l_partkey
WHERE p.p_brand = &&&_A
  AND p.p_container = &&&_B
  AND l.l_quantity < pa.threshold;