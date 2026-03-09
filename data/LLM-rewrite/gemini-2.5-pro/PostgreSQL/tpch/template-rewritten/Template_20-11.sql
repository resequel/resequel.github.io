
SELECT s.s_name,
       count(*) AS numwait
FROM supplier s
JOIN nation n ON s.s_nationkey = n.n_nationkey
JOIN lineitem l1 ON s.s_suppkey = l1.l_suppkey
JOIN orders o ON l1.l_orderkey = o.o_orderkey
WHERE o.o_orderstatus = &&&_A
  AND n.n_name = &&&_B
  AND l1.l_receiptdate > l1.l_commitdate
  AND EXISTS
    (SELECT 1
     FROM lineitem l2
     WHERE l2.l_orderkey = l1.l_orderkey
       AND l2.l_suppkey <> l1.l_suppkey)
  AND NOT EXISTS
    (SELECT 1
     FROM lineitem l3
     WHERE l3.l_orderkey = l1.l_orderkey
       AND l3.l_suppkey <> l1.l_suppkey
       AND l3.l_receiptdate > l3.l_commitdate)
GROUP BY s.s_name
ORDER BY numwait DESC,
         s.s_name
LIMIT ###_A;