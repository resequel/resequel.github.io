
SELECT sum(l.l_extendedprice) / 7.0 AS avg_yearly
FROM lineitem l
JOIN
  (SELECT p_partkey
   FROM part
   WHERE p_brand = 'Brand#23'
     AND p_container = 'MED BOX') p ON l.l_partkey = p.p_partkey
WHERE l.l_quantity <
    (SELECT 0.2 * avg(l2.l_quantity)
     FROM lineitem l2
     WHERE l2.l_partkey = p.p_partkey);