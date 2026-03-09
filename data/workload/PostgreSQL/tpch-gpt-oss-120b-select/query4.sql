SELECT o.o_orderpriority,
       COUNT(*) AS order_count
FROM   orders o
WHERE  o.o_orderdate >= DATE '1993-07-01'
  AND  o.o_orderdate <  DATE '1993-07-01' + interval '3' MONTH
  AND  EXISTS (SELECT 1
               FROM   lineitem li
               WHERE  li.l_orderkey = o.o_orderkey
                 AND  li.l_commitdate < li.l_receiptdate)
GROUP  BY o.o_orderpriority
ORDER  BY o.o_orderpriority;