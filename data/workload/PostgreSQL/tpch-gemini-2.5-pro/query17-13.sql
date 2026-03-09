
SELECT (sum(l.l_extendedprice) / 7.0) AS avg_yearly
FROM lineitem l
INNER JOIN part p ON l.l_partkey = p.p_partkey
WHERE p.p_brand = 'Brand#23'
  AND p.p_container = 'MED BOX'
  AND l.l_quantity <
    (SELECT 0.2 * avg(l_quantity)
     FROM lineitem
     WHERE l_partkey = p.p_partkey);