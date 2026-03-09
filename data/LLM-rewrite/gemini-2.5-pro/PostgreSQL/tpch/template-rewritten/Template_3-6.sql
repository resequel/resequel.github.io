WITH l AS
  (SELECT l_orderkey
   FROM lineitem
   WHERE l_commitdate < l_receiptdate)
SELECT o_orderpriority,
       count(*) AS order_count
FROM orders o
WHERE o_orderdate >= date &&&_A
  AND o_orderdate < date &&&_B + interval &&&_C MONTH
  AND o.o_orderkey IN
    (SELECT l_orderkey
     FROM l)
GROUP BY o_orderpriority
ORDER BY o_orderpriority;