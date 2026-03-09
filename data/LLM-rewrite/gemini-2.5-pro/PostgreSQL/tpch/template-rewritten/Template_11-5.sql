
SELECT c.c_name,
       c.c_custkey,
       o.o_orderkey,
       o.o_orderdate,
       o.o_totalprice,
       l.sum_qty
FROM orders o
JOIN
  (SELECT l_orderkey,
          sum(l_quantity) AS sum_qty
   FROM lineitem
   GROUP BY l_orderkey
   HAVING sum(l_quantity) > ###_A) l ON o.o_orderkey = l.l_orderkey
JOIN customer c ON o.o_custkey = c.c_custkey
ORDER BY o.o_totalprice DESC,
         o.o_orderdate
LIMIT ###_B;