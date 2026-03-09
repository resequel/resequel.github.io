WITH base AS
  (SELECT l.l_shipmode,
          o.o_orderpriority
   FROM lineitem l
   JOIN orders o ON o.o_orderkey = l.l_orderkey
   WHERE l.l_shipmode IN ('MAIL', 'SHIP')
     AND l.l_commitdate < l.l_receiptdate
     AND l.l_shipdate < l.l_commitdate
     AND l.l_receiptdate >= DATE '1994-01-01'
     AND l.l_receiptdate < CAST('1994-01-01' AS DATE) + INTERVAL '1' YEAR)
SELECT shipmode,
       SUM(high_cnt) AS high_line_count,
       SUM(low_cnt) AS low_line_count
FROM
  (SELECT l_shipmode AS shipmode,
          1 AS high_cnt,
          0 AS low_cnt
   FROM base
   WHERE o_orderpriority IN ('1-URGENT',
                             '2-HIGH')
   UNION ALL SELECT l_shipmode,
                    0,
                    1
   FROM base
   WHERE o_orderpriority NOT IN ('1-URGENT',
                                 '2-HIGH')) s
GROUP BY shipmode
ORDER BY shipmode;