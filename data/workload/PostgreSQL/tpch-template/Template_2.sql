SELECT sum(l_extendedprice) / ^^^_A AS avg_yearly
FROM lineitem,
     part
WHERE p_partkey = l_partkey
  AND p_brand = &&&_A
  AND p_container = &&&_B
  AND l_quantity <
    (SELECT ^^^_B * avg(l_quantity)
     FROM lineitem
     WHERE l_partkey = p_partkey);