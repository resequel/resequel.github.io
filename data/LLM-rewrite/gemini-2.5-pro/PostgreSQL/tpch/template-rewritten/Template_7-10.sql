
SELECT c_count,
       count(*) AS custdist
FROM
  (SELECT c.c_custkey,
          fo.c_count
   FROM customer c
   LEFT JOIN LATERAL
     (SELECT count(o_orderkey) AS c_count
      FROM orders
      WHERE o_custkey = c.c_custkey
        AND o_comment NOT LIKE &&&_A) fo ON TRUE) AS c_orders
GROUP BY c_count
ORDER BY custdist DESC,
         c_count DESC;