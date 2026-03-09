
SELECT l.l_shipmode,
       sum(CASE
               WHEN o.o_orderpriority = '1-URGENT'
                    OR o.o_orderpriority = '2-HIGH' THEN 1
               ELSE 0
           END) AS high_line_count,
       sum(CASE
               WHEN o.o_orderpriority <> '1-URGENT'
                    AND o.o_orderpriority <> '2-HIGH' THEN 1
               ELSE 0
           END) AS low_line_count
FROM
  (SELECT l_orderkey,
          l_shipmode
   FROM lineitem
   WHERE l_shipmode IN ('MAIL',
                     'SHIP')
     AND l_commitdate < l_receiptdate
     AND l_shipdate < l_commitdate
     AND l_receiptdate >= date '1994-01-01'
     AND l_receiptdate < date '1994-01-01' + interval '1' YEAR) l
JOIN
  (SELECT o_orderkey,
          o_orderpriority
   FROM orders) o ON l.l_orderkey = o.o_orderkey
GROUP BY l.l_shipmode
ORDER BY l.l_shipmode;