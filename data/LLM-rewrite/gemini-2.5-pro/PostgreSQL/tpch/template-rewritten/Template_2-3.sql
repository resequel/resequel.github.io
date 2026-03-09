WITH p AS
  (SELECT p_partkey
   FROM part
   WHERE p_brand = &&&_A
     AND p_container = &&&_B)
SELECT sum(calc.l_extendedprice) / ^^^_A AS avg_yearly
FROM
  (SELECT l.l_extendedprice,
          l.l_quantity, ^^^_B * avg(l.l_quantity) OVER (PARTITION BY l.l_partkey) AS threshold
   FROM lineitem l
   JOIN p ON l.l_partkey = p.p_partkey) calc
WHERE calc.l_quantity < calc.threshold;