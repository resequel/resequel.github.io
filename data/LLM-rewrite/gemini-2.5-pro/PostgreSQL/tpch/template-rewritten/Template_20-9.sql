WITH l1 AS
  (SELECT l_orderkey,
          l_suppkey
   FROM lineitem
   WHERE l_receiptdate > l_commitdate),
     l2 AS
  (SELECT l_orderkey
   FROM lineitem
   GROUP BY l_orderkey
   HAVING count(DISTINCT l_suppkey) > 1),
     l3 AS
  (SELECT l_orderkey
   FROM lineitem
   WHERE l_receiptdate > l_commitdate
   GROUP BY l_orderkey
   HAVING count(DISTINCT l_suppkey) = 1)
SELECT s.s_name,
       count(*) AS numwait
FROM l1
JOIN l2 ON l1.l_orderkey = l2.l_orderkey
JOIN l3 ON l1.l_orderkey = l3.l_orderkey
JOIN orders o ON l1.l_orderkey = o.o_orderkey
JOIN supplier s ON l1.l_suppkey = s.s_suppkey
JOIN nation n ON s.s_nationkey = n.n_nationkey
WHERE o.o_orderstatus = &&&_A
  AND n.n_name = &&&_B
GROUP BY s.s_name
ORDER BY numwait DESC,
         s.s_name
LIMIT ###_A;