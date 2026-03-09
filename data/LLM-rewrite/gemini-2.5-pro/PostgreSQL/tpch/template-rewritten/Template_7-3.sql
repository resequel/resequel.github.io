WITH o_counts AS
  (SELECT o_custkey,
          count(o_orderkey) AS c_count
   FROM orders
   WHERE o_comment NOT LIKE &&&_A
   GROUP BY o_custkey)
SELECT CASE
           WHEN o.c_count IS NULL THEN 0
           ELSE o.c_count
       END AS c_count,
       count(*) AS custdist
FROM customer c
LEFT JOIN o_counts o ON c.c_custkey = o.o_custkey
GROUP BY CASE
             WHEN o.c_count IS NULL THEN 0
             ELSE o.c_count
         END
ORDER BY custdist DESC,
         c_count DESC;