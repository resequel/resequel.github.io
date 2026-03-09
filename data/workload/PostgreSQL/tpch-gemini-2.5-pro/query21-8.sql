WITH sn AS
  (SELECT s_suppkey,
          s_name
   FROM supplier
   JOIN nation ON s_nationkey = n_nationkey
   WHERE n_name = 'SAUDI ARABIA'),
     o AS
  (SELECT o_orderkey
   FROM orders
   WHERE o_orderstatus = 'F')
SELECT sn.s_name,
       count(*) AS numwait
FROM sn
JOIN lineitem l1 ON sn.s_suppkey = l1.l_suppkey
JOIN o ON l1.l_orderkey = o.o_orderkey
WHERE l1.l_receiptdate > l1.l_commitdate
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
GROUP BY sn.s_name
ORDER BY numwait DESC,
         sn.s_name
LIMIT 100;