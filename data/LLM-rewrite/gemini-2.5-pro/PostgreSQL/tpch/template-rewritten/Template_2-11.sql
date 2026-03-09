WITH p AS
  (SELECT p_partkey
   FROM part
   WHERE p_brand = &&&_A
     AND p_container = &&&_B)
SELECT sum(l.l_extendedprice) / ^^^_A AS avg_yearly
FROM lineitem l
JOIN p ON l.l_partkey = p.p_partkey
WHERE l.l_quantity <
    (SELECT ^^^_B * avg(l2.l_quantity)
     FROM lineitem l2
     WHERE l2.l_partkey = l.l_partkey);