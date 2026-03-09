
SELECT o_orderpriority,
       count(*) AS order_count
FROM orders o
WHERE EXISTS
    (SELECT 1
     FROM lineitem l
     WHERE l.l_orderkey = o.o_orderkey
       AND l.l_commitdate < l.l_receiptdate
     GROUP BY l.l_orderkey)
  AND o.o_orderdate >= date '1993-07-01'
  AND o.o_orderdate < date '1993-07-01' + interval '3' MONTH
GROUP BY o_orderpriority
ORDER BY o_orderpriority;