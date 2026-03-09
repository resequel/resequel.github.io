
SELECT c.c_name,
       c.c_custkey,
       o.o_orderkey,
       o.o_orderdate,
       o.o_totalprice,
       sum(l.l_quantity)
FROM orders o
JOIN customer c ON o.o_custkey = c.c_custkey
JOIN lineitem l ON o.o_orderkey = l.l_orderkey
WHERE o.o_orderkey IN
    (SELECT l_orderkey
     FROM lineitem
     GROUP BY l_orderkey
     HAVING sum(l_quantity) > ###_A)
GROUP BY c.c_name,
         c.c_custkey,
         o.o_orderkey,
         o.o_orderdate,
         o.o_totalprice
ORDER BY o.o_totalprice DESC,
         o.o_orderdate
LIMIT ###_B;