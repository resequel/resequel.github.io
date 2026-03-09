
SELECT c_name,
       c_custkey,
       o_orderkey,
       o_orderdate,
       o_totalprice,
       sum(l_quantity)
FROM lineitem l
JOIN orders o ON l.l_orderkey = o.o_orderkey
JOIN customer c ON o.o_custkey = c.c_custkey
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