
SELECT sum(calc.l_extendedprice) / ^^^_A AS avg_yearly
FROM
  (SELECT l.l_extendedprice,
          l.l_quantity, ^^^_B * avg(l.l_quantity) OVER (PARTITION BY l.l_partkey) AS threshold
   FROM lineitem l
   JOIN part p ON l.l_partkey = p.p_partkey
   WHERE p.p_brand = &&&_A
     AND p.p_container = &&&_B) calc
WHERE calc.l_quantity < calc.threshold;