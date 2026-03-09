
SELECT c_name,
       c_custkey,
       o_orderkey,
       o_orderdate,
       o_totalprice,
       sum(l_quantity)
FROM orders o
JOIN customer c ON o.o_custkey = c.c_custkey
JOIN lineitem l ON o.o_orderkey = l.l_orderkey
WHERE o.o_orderkey IN
    (SELECT l_orderkey
     FROM lineitem
     GROUP BY l_orderkey
     HAVING sum(l_quantity) > ###_A)
GROUP BY c_name,
         c_custkey,
         o_orderkey,
         o_orderdate,
         o_totalprice
ORDER BY o_totalprice DESC,
         o_orderdate
LIMIT ###_B;