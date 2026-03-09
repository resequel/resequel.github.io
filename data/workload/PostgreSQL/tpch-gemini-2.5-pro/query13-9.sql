
SELECT c_orders.c_count,
       count(c_orders.c_custkey) AS custdist
FROM
  (SELECT customer.c_custkey,
          count(orders.o_orderkey) AS c_count
   FROM customer
   LEFT OUTER JOIN orders ON customer.c_custkey = orders.o_custkey
   AND orders.o_comment NOT LIKE '%special%requests%'
   GROUP BY customer.c_custkey) AS c_orders
GROUP BY c_orders.c_count
ORDER BY custdist DESC,
         c_orders.c_count DESC;