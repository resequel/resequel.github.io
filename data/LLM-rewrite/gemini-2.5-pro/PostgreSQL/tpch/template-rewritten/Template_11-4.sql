WITH l_agg AS
  (SELECT l_orderkey,
          sum(l_quantity) AS sum_qty
   FROM lineitem
   GROUP BY l_orderkey
   HAVING sum(l_quantity) > ###_A),
     o_filtered AS
  (SELECT o_orderkey,
          o_custkey,
          o_orderdate,
          o_totalprice
   FROM orders)
SELECT c.c_name,
       c.c_custkey,
       o.o_orderkey,
       o.o_orderdate,
       o.o_totalprice,
       l.sum_qty
FROM l_agg l
JOIN o_filtered o ON l.l_orderkey = o.o_orderkey
JOIN customer c ON o.o_custkey = c.c_custkey
ORDER BY o.o_totalprice DESC,
         o.o_orderdate
LIMIT ###_B;