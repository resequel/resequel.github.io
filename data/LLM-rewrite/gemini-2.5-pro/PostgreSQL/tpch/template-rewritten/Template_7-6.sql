WITH filtered_orders AS
  (SELECT o_orderkey,
          o_custkey
   FROM orders
   WHERE o_comment NOT LIKE &&&_A)
SELECT c_count,
       count(*) AS custdist
FROM
  (SELECT c.c_custkey,
          count(fo.o_orderkey) AS c_count
   FROM customer c
   LEFT JOIN filtered_orders fo ON c.c_custkey = fo.o_custkey
   GROUP BY c.c_custkey) AS c_orders
GROUP BY c_count
ORDER BY custdist DESC,
         c_count DESC;