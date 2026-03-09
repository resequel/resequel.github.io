
SELECT sum(calc.l_extendedprice) / ^^^_A AS avg_yearly
FROM
  (SELECT l.l_extendedprice,
          l.l_quantity,
          avg(l.l_quantity) OVER (PARTITION BY l.l_partkey) AS avg_q
   FROM lineitem l
   INNER JOIN part p ON l.l_partkey = p.p_partkey
   WHERE p.p_brand = &&&_A
     AND p.p_container = &&&_B) calc
WHERE calc.l_quantity < ^^^_B * calc.avg_q;