WITH o AS
  (SELECT o_orderkey,
          o_orderpriority
   FROM orders
   WHERE o_orderdate >= date &&&_A
     AND o_orderdate < date &&&_B + interval &&&_C MONTH),
     l AS
  (SELECT DISTINCT l_orderkey
   FROM lineitem
   WHERE l_commitdate < l_receiptdate)
SELECT o.o_orderpriority,
       count(*) AS order_count
FROM o
JOIN l ON o.o_orderkey = l.l_orderkey
GROUP BY o.o_orderpriority
ORDER BY o.o_orderpriority;