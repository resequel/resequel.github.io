WITH p AS
  (SELECT p_partkey
   FROM part
   WHERE p_brand = 'Brand#23'
     AND p_container = 'MED BOX')
SELECT sum(calc.l_extendedprice) / 7.0 AS avg_yearly
FROM
  (SELECT l.l_extendedprice,
          l.l_quantity,
          avg(l.l_quantity) OVER (PARTITION BY l.l_partkey) AS avg_q
   FROM lineitem l
   JOIN p ON l.l_partkey = p.p_partkey) calc
WHERE calc.l_quantity < 0.2 * calc.avg_q;