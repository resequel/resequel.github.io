
SELECT sum(calc.l_extendedprice) / 7.0 AS avg_yearly
FROM
  (SELECT l.l_extendedprice,
          l.l_quantity, 0.2 * avg(l.l_quantity) OVER (PARTITION BY l.l_partkey) AS threshold
   FROM lineitem l
   JOIN part p ON l.l_partkey = p.p_partkey
   WHERE p.p_brand = 'Brand#23'
     AND p.p_container = 'MED BOX') calc
WHERE calc.l_quantity < calc.threshold;