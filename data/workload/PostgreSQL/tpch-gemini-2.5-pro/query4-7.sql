WITH l AS
  (SELECT DISTINCT l_orderkey
   FROM lineitem
   WHERE l_commitdate < l_receiptdate)
SELECT o.o_orderpriority,
       count(*) AS order_count
FROM orders o
JOIN l ON o.o_orderkey = l.l_orderkey
WHERE o.o_orderdate >= date '1993-07-01'
  AND o.o_orderdate < date '1993-07-01' + interval '3' MONTH
GROUP BY o.o_orderpriority
ORDER BY o.o_orderpriority;