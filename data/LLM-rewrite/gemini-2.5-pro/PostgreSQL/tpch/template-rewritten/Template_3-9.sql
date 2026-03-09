WITH l AS
  (SELECT DISTINCT l_orderkey
   FROM lineitem
   WHERE l_commitdate < l_receiptdate)
SELECT o.o_orderpriority,
       count(*) AS order_count
FROM orders o
JOIN l ON o.o_orderkey = l.l_orderkey
WHERE o.o_orderdate >= date &&&_A
  AND o.o_orderdate < date &&&_B + interval &&&_C MONTH
GROUP BY o.o_orderpriority
ORDER BY o.o_orderpriority;