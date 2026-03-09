WITH l_stats AS
  (SELECT l_orderkey,
          count(DISTINCT l_suppkey) AS supp_count,
          count(DISTINCT CASE
                             WHEN l_receiptdate > l_commitdate THEN l_suppkey
                         END) AS late_supp_count,
          max(CASE
                  WHEN l_receiptdate > l_commitdate THEN l_suppkey
              END) AS late_supp
   FROM lineitem
   GROUP BY l_orderkey
   HAVING count(DISTINCT l_suppkey) > 1
   AND count(DISTINCT CASE
                          WHEN l_receiptdate > l_commitdate THEN l_suppkey
                      END) = 1)
SELECT s.s_name,
       count(*) AS numwait
FROM l_stats ls
JOIN orders o ON ls.l_orderkey = o.o_orderkey
JOIN supplier s ON ls.late_supp = s.s_suppkey
JOIN nation n ON s.s_nationkey = n.n_nationkey
WHERE o.o_orderstatus = &&&_A
  AND n.n_name = &&&_B
GROUP BY s.s_name
ORDER BY numwait DESC,
         s.s_name
LIMIT ###_A;