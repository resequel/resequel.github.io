
SELECT l.l_shipmode,
       sum(CASE
               WHEN o.o_orderpriority = &&&_A
                    OR o.o_orderpriority = &&&_B THEN ###_A
               ELSE ###_B
           END) AS high_line_count,
       sum(CASE
               WHEN o.o_orderpriority <> &&&_C
                    AND o.o_orderpriority <> &&&_D THEN ###_C
               ELSE ###_D
           END) AS low_line_count
FROM lineitem l
INNER JOIN orders o ON l.l_orderkey = o.o_orderkey
WHERE l.l_shipmode IN N_SSS_A
  AND l.l_commitdate < l.l_receiptdate
  AND l.l_shipdate < l.l_commitdate
  AND l.l_receiptdate >= date &&&_E
  AND l.l_receiptdate < date &&&_F + interval &&&_G YEAR
GROUP BY l.l_shipmode
ORDER BY l.l_shipmode;