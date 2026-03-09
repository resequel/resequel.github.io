WITH c_orders AS
  (SELECT c.c_custkey,
          count(o.o_orderkey) AS c_count
   FROM customer c
   LEFT OUTER JOIN orders o ON c.c_custkey = o.o_custkey
   AND o.o_comment NOT LIKE &&&_A
   GROUP BY c.c_custkey)
SELECT c_count,
       count(*) AS custdist
FROM c_orders
GROUP BY c_count
ORDER BY custdist DESC,
         c_count DESC;