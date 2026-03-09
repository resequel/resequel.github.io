
SELECT nation,
       o_year,
       sum(amount) AS sum_profit
FROM
  (SELECT n_name AS nation,
          extract(YEAR
                  FROM o_orderdate) AS o_year,
          l_extendedprice * (###_A - l_discount) - ps_supplycost * l_quantity AS amount
   FROM lineitem
   INNER JOIN part ON p_partkey = l_partkey
   INNER JOIN partsupp ON ps_partkey = l_partkey
   AND ps_suppkey = l_suppkey
   INNER JOIN orders ON o_orderkey = l_orderkey
   INNER JOIN supplier ON s_suppkey = l_suppkey
   INNER JOIN nation ON s_nationkey = n_nationkey
   WHERE p_name LIKE &&&_A) AS profit
GROUP BY nation,
         o_year
ORDER BY nation,
         o_year DESC;