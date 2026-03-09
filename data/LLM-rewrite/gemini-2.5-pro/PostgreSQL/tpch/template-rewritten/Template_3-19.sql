
SELECT o_orderpriority,
       count(o_orderkey) AS order_count
FROM orders
WHERE EXISTS
    (SELECT 1
     FROM lineitem
     WHERE l_orderkey = o_orderkey
       AND l_commitdate < l_receiptdate)
  AND o_orderdate >= date &&&_A
  AND o_orderdate < date &&&_B + interval &&&_C MONTH
GROUP BY o_orderpriority
ORDER BY o_orderpriority;