
SELECT sn.s_name,
       count(*) AS numwait
FROM
  (SELECT l_orderkey,
          max(CASE
                  WHEN l_receiptdate > l_commitdate THEN l_suppkey
              END) AS late_supp
   FROM lineitem
   GROUP BY l_orderkey
   HAVING count(DISTINCT l_suppkey) > 1
   AND count(DISTINCT CASE
                          WHEN l_receiptdate > l_commitdate THEN l_suppkey
                      END) = 1) ls
JOIN
  (SELECT o_orderkey
   FROM orders
   WHERE o_orderstatus = &&&_A) o ON ls.l_orderkey = o.o_orderkey
JOIN
  (SELECT s_suppkey,
          s_name
   FROM supplier
   JOIN nation ON s_nationkey = n_nationkey
   WHERE n_name = &&&_B) sn ON ls.late_supp = sn.s_suppkey
GROUP BY sn.s_name
ORDER BY numwait DESC,
         sn.s_name
LIMIT ###_A;