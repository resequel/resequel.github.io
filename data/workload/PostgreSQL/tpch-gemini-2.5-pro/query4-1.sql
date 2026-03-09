WITH l AS
  (SELECT l_orderkey
   FROM lineitem
   WHERE l_commitdate < l_receiptdate)
SELECT o_orderpriority,
       count(*) AS order_count
FROM orders o
WHERE o_orderdate >= date '1993-07-01'
  AND o_orderdate < date '1993-07-01' + interval '3' MONTH
  AND o.o_orderkey IN
    (SELECT l_orderkey
     FROM l)
GROUP BY o_orderpriority
ORDER BY o_orderpriority;