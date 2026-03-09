
SELECT o.o_orderpriority,
       count(*) AS order_count
FROM
  (SELECT o_orderkey,
          o_orderpriority
   FROM orders
   WHERE o_orderdate >= date &&&_A
     AND o_orderdate < date &&&_B + interval &&&_C MONTH) o
JOIN
  (SELECT l_orderkey
   FROM lineitem
   WHERE l_commitdate < l_receiptdate
   GROUP BY l_orderkey) l ON o.o_orderkey = l.l_orderkey
GROUP BY o.o_orderpriority
ORDER BY o.o_orderpriority;