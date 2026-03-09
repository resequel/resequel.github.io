
SELECT n_name AS nation,
       extract(YEAR
               FROM o_orderdate) AS o_year,
       sum(l_extendedprice * (1 - l_discount) - ps_supplycost * l_quantity) AS sum_profit
FROM part
INNER JOIN lineitem ON p_partkey = l_partkey
INNER JOIN partsupp ON ps_partkey = l_partkey
AND ps_suppkey = l_suppkey
INNER JOIN supplier ON s_suppkey = l_suppkey
INNER JOIN nation ON s_nationkey = n_nationkey
INNER JOIN orders ON o_orderkey = l_orderkey
WHERE p_name LIKE '%green%'
GROUP BY n_name,
         extract(YEAR
                 FROM o_orderdate)
ORDER BY nation,
         o_year DESC;