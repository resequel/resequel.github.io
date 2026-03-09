
SELECT l_shipmode,
       sum(CASE
               WHEN o_orderpriority IN (&&&_A, &&&_B) THEN ###_A
               ELSE ###_B
           END) AS high_line_count,
       sum(CASE
               WHEN o_orderpriority NOT IN (&&&_C, &&&_D) THEN ###_C
               ELSE ###_D
           END) AS low_line_count
FROM lineitem
INNER JOIN orders ON o_orderkey = l_orderkey
AND l_shipmode IN N_SSS_A
AND l_commitdate < l_receiptdate
AND l_shipdate < l_commitdate
AND l_receiptdate >= date &&&_E
AND l_receiptdate < date &&&_F + interval &&&_G YEAR
GROUP BY l_shipmode
ORDER BY l_shipmode;