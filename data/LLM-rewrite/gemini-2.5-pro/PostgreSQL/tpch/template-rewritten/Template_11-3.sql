
SELECT c.c_name,
       c.c_custkey,
       o.o_orderkey,
       o.o_orderdate,
       o.o_totalprice,
       l.sum_qty
FROM
  (SELECT l_orderkey,
          sum(l_quantity) AS sum_qty
   FROM lineitem
   GROUP BY l_orderkey
   HAVING sum(l_quantity) > ###_A) l
JOIN orders o ON l.l_orderkey = o.o_orderkey
JOIN customer c ON o.o_custkey = c.c_custkey
ORDER BY o.o_totalprice DESC,
         o.o_orderdate
LIMIT ###_B;