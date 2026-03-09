
SELECT o.o_orderpriority,
       count(*) AS order_count
FROM
  (SELECT o_orderkey,
          o_orderpriority
   FROM orders
   WHERE o_orderdate >= date '1993-07-01'
     AND o_orderdate < date '1993-07-01' + interval '3' MONTH) o
WHERE EXISTS
    (SELECT 1
     FROM lineitem l
     WHERE l.l_orderkey = o.o_orderkey
       AND l.l_commitdate < l.l_receiptdate)
GROUP BY o.o_orderpriority
ORDER BY o.o_orderpriority;