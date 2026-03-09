
SELECT o.o_orderpriority,
       count(*) AS order_count
FROM
  (SELECT o_orderkey,
          o_orderpriority
   FROM orders
   WHERE o_orderdate >= date '1993-07-01'
     AND o_orderdate < date '1993-07-01' + interval '3' MONTH) o
WHERE o.o_orderkey IN
    (SELECT l_orderkey
     FROM lineitem
     WHERE l_commitdate < l_receiptdate)
GROUP BY o.o_orderpriority
ORDER BY o.o_orderpriority;