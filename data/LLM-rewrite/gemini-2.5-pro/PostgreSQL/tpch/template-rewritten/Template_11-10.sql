WITH valid_orders AS
  (SELECT l_orderkey
   FROM lineitem
   GROUP BY l_orderkey
   HAVING sum(l_quantity) > ###_A)
SELECT c.c_name,
       c.c_custkey,
       o.o_orderkey,
       o.o_orderdate,
       o.o_totalprice,
       sum(l.l_quantity)
FROM valid_orders vo
JOIN orders o ON vo.l_orderkey = o.o_orderkey
JOIN customer c ON o.o_custkey = c.c_custkey
JOIN lineitem l ON o.o_orderkey = l.l_orderkey
GROUP BY c.c_name,
         c.c_custkey,
         o.o_orderkey,
         o.o_orderdate,
         o.o_totalprice
ORDER BY o.o_totalprice DESC,
         o.o_orderdate
LIMIT ###_B;