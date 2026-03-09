WITH valid_orders AS
  (SELECT l_orderkey,
          max(l_suppkey) AS late_supp
   FROM lineitem
   WHERE l_receiptdate > l_commitdate
   GROUP BY l_orderkey
   HAVING count(DISTINCT l_suppkey) = 1),
     multi_supp_orders AS
  (SELECT l_orderkey
   FROM lineitem
   GROUP BY l_orderkey
   HAVING count(DISTINCT l_suppkey) > 1)
SELECT s.s_name,
       count(*) AS numwait
FROM valid_orders vo
JOIN multi_supp_orders mso ON vo.l_orderkey = mso.l_orderkey
JOIN orders o ON vo.l_orderkey = o.o_orderkey
JOIN supplier s ON vo.late_supp = s.s_suppkey
JOIN nation n ON s.s_nationkey = n.n_nationkey
WHERE o.o_orderstatus = 'F'
  AND n.n_name = 'SAUDI ARABIA'
GROUP BY s.s_name
ORDER BY numwait DESC,
         s.s_name
LIMIT 100;