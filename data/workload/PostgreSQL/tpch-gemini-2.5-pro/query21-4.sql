WITH l_agg AS
  (SELECT l_orderkey,
          min(l_suppkey) AS first_supp,
          max(l_suppkey) AS last_supp,
          count(CASE
                    WHEN l_receiptdate > l_commitdate THEN 1
                END) AS late_cnt,
          max(CASE
                  WHEN l_receiptdate > l_commitdate THEN l_suppkey
              END) AS late_supp
   FROM lineitem
   GROUP BY l_orderkey
   HAVING min(l_suppkey) <> max(l_suppkey)
   AND count(CASE
                 WHEN l_receiptdate > l_commitdate THEN 1
             END) > 0),
     o AS
  (SELECT o_orderkey
   FROM orders
   WHERE o_orderstatus = 'F'),
     sn AS
  (SELECT s_suppkey,
          s_name
   FROM supplier
   JOIN nation ON s_nationkey = n_nationkey
   WHERE n_name = 'SAUDI ARABIA')
SELECT sn.s_name,
       count(*) AS numwait
FROM l_agg
JOIN o ON l_agg.l_orderkey = o.o_orderkey
JOIN sn ON l_agg.late_supp = sn.s_suppkey
WHERE l_agg.late_cnt = 1
  OR l_agg.late_supp =
    (SELECT min(l.l_suppkey)
     FROM lineitem l
     WHERE l.l_orderkey = l_agg.l_orderkey
       AND l.l_receiptdate > l.l_commitdate)
GROUP BY sn.s_name
ORDER BY numwait DESC,
         sn.s_name
LIMIT 100;