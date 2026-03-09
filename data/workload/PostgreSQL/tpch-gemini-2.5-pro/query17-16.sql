
SELECT sum(lineitem.l_extendedprice) / 7.0 AS avg_yearly
FROM lineitem
INNER JOIN part ON part.p_partkey = lineitem.l_partkey
WHERE part.p_brand = 'Brand#23'
  AND part.p_container = 'MED BOX'
  AND lineitem.l_quantity <
    (SELECT 0.2 * avg(l_quantity)
     FROM lineitem
     WHERE l_partkey = part.p_partkey);