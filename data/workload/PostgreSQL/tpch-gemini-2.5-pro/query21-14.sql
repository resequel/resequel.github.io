WITH o AS
  (SELECT o_orderkey
   FROM orders
   WHERE o_orderstatus = 'F'),
     sn AS
  (SELECT s_suppkey,
          s_name
   FROM supplier
   JOIN nation ON s_nationkey = n_nationkey
   WHERE n_name = 'SAUDI ARABIA'),
     l_stats AS
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
SELECT sn.s_name,
       count(*) AS numwait
FROM l_stats ls
JOIN o ON ls.l_orderkey = o.o_orderkey
JOIN sn ON ls.late_supp = sn.s_suppkey
GROUP BY sn.s_name
ORDER BY numwait DESC,
         sn.s_name
LIMIT 100;