
SELECT COALESCE(o.c_count, 0) AS c_count,
       count(*) AS custdist
FROM customer c
LEFT JOIN
  (SELECT o_custkey,
          count(o_orderkey) AS c_count
   FROM orders
   WHERE o_comment NOT LIKE &&&_A
   GROUP BY o_custkey) o ON c.c_custkey = o.o_custkey
GROUP BY COALESCE(o.c_count, 0)
ORDER BY custdist DESC,
         c_count DESC;