
SELECT SUM(li.l_extendedprice) / 7.0 AS avg_yearly
FROM lineitem li
JOIN part p ON p.p_partkey = li.l_partkey
CROSS JOIN LATERAL
  (SELECT 0.2 * avg(l_quantity) AS qty_thr
   FROM lineitem
   WHERE l_partkey = p.p_partkey) AS thr
WHERE p.p_brand = 'Brand#23'
  AND p.p_container = 'MED BOX'
  AND li.l_quantity < thr.qty_thr;