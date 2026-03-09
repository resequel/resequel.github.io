
SELECT o_orderpriority,
       count(*) AS order_count
FROM orders o
WHERE o.o_orderdate >= date &&&_A
  AND o.o_orderdate < date &&&_B + interval &&&_C MONTH
  AND EXISTS
    (SELECT 1
     FROM lineitem l
     WHERE l.l_orderkey = o.o_orderkey
       AND l.l_commitdate < l.l_receiptdate)
GROUP BY o_orderpriority
ORDER BY o_orderpriority;