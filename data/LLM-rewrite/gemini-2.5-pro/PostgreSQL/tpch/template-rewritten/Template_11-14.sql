
SELECT c.c_name,
       c.c_custkey,
       o.o_orderkey,
       o.o_orderdate,
       o.o_totalprice,
       sum(l.l_quantity)
FROM customer c
INNER JOIN orders o ON c.c_custkey = o.o_custkey
INNER JOIN lineitem l ON o.o_orderkey = l.l_orderkey
WHERE EXISTS
    (SELECT 1
     FROM
       (SELECT l_orderkey
        FROM lineitem
        GROUP BY l_orderkey
        HAVING sum(l_quantity) > ###_A) sub
     WHERE sub.l_orderkey = o.o_orderkey)
GROUP BY c.c_name,
         c.c_custkey,
         o.o_orderkey,
         o.o_orderdate,
         o.o_totalprice
ORDER BY o.o_totalprice DESC,
         o.o_orderdate
LIMIT ###_B;