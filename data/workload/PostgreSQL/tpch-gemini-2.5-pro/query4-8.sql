
SELECT o_orderpriority,
       count(1) AS order_count
FROM orders
WHERE o_orderdate >= date '1993-07-01'
  AND o_orderdate < date '1993-07-01' + interval '3' MONTH
  AND EXISTS
    (SELECT 1
     FROM lineitem
     WHERE l_orderkey = o_orderkey
       AND l_commitdate < l_receiptdate)
GROUP BY o_orderpriority
ORDER BY o_orderpriority;