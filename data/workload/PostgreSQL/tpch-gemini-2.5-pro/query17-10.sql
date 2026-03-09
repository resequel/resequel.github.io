
SELECT sum(l.l_extendedprice) / 7.0 AS avg_yearly
FROM lineitem l
JOIN part p ON l.l_partkey = p.p_partkey
JOIN
  (SELECT l_partkey, 0.2 * avg(l_quantity) AS threshold
   FROM lineitem
   GROUP BY l_partkey) pa ON l.l_partkey = pa.l_partkey
WHERE p.p_brand = 'Brand#23'
  AND p.p_container = 'MED BOX'
  AND l.l_quantity < pa.threshold;