
SELECT o_orderpriority,
       count(*) AS order_count
FROM orders
WHERE o_orderdate >= date &&&_A
  AND o_orderdate < date &&&_B + interval &&&_C MONTH
  AND o_orderkey IN
    (SELECT DISTINCT l_orderkey
     FROM lineitem
     WHERE l_commitdate < l_receiptdate)
GROUP BY o_orderpriority
ORDER BY o_orderpriority;