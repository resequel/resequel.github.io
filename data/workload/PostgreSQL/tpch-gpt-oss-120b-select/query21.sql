WITH filtered_lineitem AS (
    SELECT l_orderkey, l_suppkey
    FROM   lineitem
    WHERE  l_receiptdate > l_commitdate
)
SELECT s.s_name,
       COUNT(*) AS numwait
FROM   supplier s
JOIN   filtered_lineitem fl ON s.s_suppkey = fl.l_suppkey
JOIN   orders o    ON o.o_orderkey = fl.l_orderkey
JOIN   nation n    ON s.s_nationkey = n.n_nationkey
WHERE  o.o_orderstatus = 'F'
  AND  n.n_name = 'SAUDI ARABIA'
  AND  EXISTS (SELECT 1
               FROM   lineitem l2
               WHERE  l2.l_orderkey = fl.l_orderkey
                 AND  l2.l_suppkey <> fl.l_suppkey)
  AND  NOT EXISTS (SELECT 1
                   FROM   lineitem l3
                   WHERE  l3.l_orderkey = fl.l_orderkey
                     AND  l3.l_suppkey <> fl.l_suppkey
                     AND  l3.l_receiptdate > l3.l_commitdate)
GROUP  BY s.s_name
ORDER  BY numwait DESC, s.s_name
LIMIT  100;