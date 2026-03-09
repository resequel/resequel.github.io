
SELECT sum(l.l_extendedprice) / ^^^_A AS avg_yearly
FROM lineitem l,
     part p
WHERE p.p_partkey = l.l_partkey
  AND p.p_brand = &&&_A
  AND p.p_container = &&&_B
  AND l.l_quantity <
    (SELECT ^^^_B * avg(l2.l_quantity)
     FROM lineitem l2
     WHERE l2.l_partkey = l.l_partkey);