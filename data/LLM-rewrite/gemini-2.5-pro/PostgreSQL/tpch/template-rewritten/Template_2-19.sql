
SELECT sum(lineitem.l_extendedprice) / ^^^_A AS avg_yearly
FROM lineitem
INNER JOIN part ON part.p_partkey = lineitem.l_partkey
WHERE part.p_brand = &&&_A
  AND part.p_container = &&&_B
  AND lineitem.l_quantity <
    (SELECT ^^^_B * avg(l_quantity)
     FROM lineitem
     WHERE l_partkey = part.p_partkey);