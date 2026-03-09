
SELECT o.o_orderpriority,
       count(o.o_orderkey) AS order_count
FROM orders o
WHERE o.o_orderdate >= date '1993-07-01'
  AND o.o_orderdate < date '1993-07-01' + interval '3' MONTH
  AND EXISTS
    (SELECT l.l_orderkey
     FROM lineitem l
     WHERE l.l_orderkey = o.o_orderkey
       AND l.l_commitdate < l.l_receiptdate)
GROUP BY o.o_orderpriority
ORDER BY o.o_orderpriority;