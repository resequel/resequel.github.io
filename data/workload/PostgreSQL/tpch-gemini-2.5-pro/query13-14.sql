
SELECT c_count,
       count(c_custkey) AS custdist
FROM
  (SELECT c.c_custkey,
          COALESCE(
                     (SELECT count(o.o_orderkey)
                      FROM orders o
                      WHERE o.o_custkey = c.c_custkey
                        AND o.o_comment NOT LIKE '%special%requests%'), 0) AS c_count
   FROM customer c) AS c_orders
GROUP BY c_count
ORDER BY custdist DESC,
         c_count DESC;