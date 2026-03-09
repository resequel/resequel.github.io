
SELECT c.c_name,
       c.c_custkey,
       o.o_orderkey,
       o.o_orderdate,
       o.o_totalprice,
       l.sum_qty
FROM customer c
JOIN orders o ON c.c_custkey = o.o_custkey
JOIN
  (SELECT l_orderkey,
          sum(l_quantity) AS sum_qty
   FROM lineitem
   GROUP BY l_orderkey) l ON o.o_orderkey = l.l_orderkey
WHERE l.sum_qty > ###_A
ORDER BY o.o_totalprice DESC,
         o.o_orderdate
LIMIT ###_B;