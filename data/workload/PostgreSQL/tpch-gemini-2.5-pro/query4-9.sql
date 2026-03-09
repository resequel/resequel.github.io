
SELECT o_orderpriority,
       count(o_orderkey) AS order_count
FROM orders
WHERE EXISTS
    (SELECT 1
     FROM lineitem
     WHERE l_orderkey = o_orderkey
       AND l_commitdate < l_receiptdate)
  AND o_orderdate >= date '1993-07-01'
  AND o_orderdate < date '1993-07-01' + interval '3' MONTH
GROUP BY o_orderpriority
ORDER BY o_orderpriority;