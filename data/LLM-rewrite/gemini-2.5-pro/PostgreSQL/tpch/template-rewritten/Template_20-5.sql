WITH l_window AS
  (SELECT l_orderkey,
          l_suppkey,
          l_receiptdate,
          l_commitdate,
          count(DISTINCT l_suppkey) OVER (PARTITION BY l_orderkey) AS total_supps,
          count(DISTINCT CASE
                             WHEN l_receiptdate > l_commitdate THEN l_suppkey
                         END) OVER (PARTITION BY l_orderkey) AS late_supps
   FROM lineitem)
SELECT s.s_name,
       count(*) AS numwait
FROM l_window lw
JOIN orders o ON lw.l_orderkey = o.o_orderkey
JOIN supplier s ON lw.l_suppkey = s.s_suppkey
JOIN nation n ON s.s_nationkey = n.n_nationkey
WHERE o.o_orderstatus = &&&_A
  AND n.n_name = &&&_B
  AND lw.l_receiptdate > lw.l_commitdate
  AND lw.total_supps > 1
  AND lw.late_supps = 1
GROUP BY s.s_name
ORDER BY numwait DESC,
         s.s_name
LIMIT ###_A;