
SELECT sum(l.l_extendedprice) / ^^^_A AS avg_yearly
FROM lineitem l
INNER JOIN part p ON l.l_partkey = p.p_partkey
WHERE p.p_brand = &&&_A
  AND p.p_container = &&&_B
  AND l.l_quantity <
    (SELECT ^^^_B * avg(l2.l_quantity)
     FROM lineitem l2
     WHERE l2.l_partkey = p.p_partkey);