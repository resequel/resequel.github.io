WITH o AS
  (SELECT o_orderkey,
          o_orderpriority
   FROM orders
   WHERE o_orderdate >= date &&&_A
     AND o_orderdate < date &&&_B + interval &&&_C MONTH)
SELECT o.o_orderpriority,
       count(*) AS order_count
FROM o
WHERE o.o_orderkey IN
    (SELECT l_orderkey
     FROM lineitem
     WHERE l_commitdate < l_receiptdate)
GROUP BY o.o_orderpriority
ORDER BY o.o_orderpriority;