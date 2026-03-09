
SELECT n1.n_name AS supp_nation,
       n2.n_name AS cust_nation,
       extract(YEAR
               FROM l_shipdate) AS l_year,
       sum(l_extendedprice * (1 - l_discount)) AS revenue
FROM lineitem l
INNER JOIN supplier s ON s.s_suppkey = l.l_suppkey
INNER JOIN nation n1 ON s.s_nationkey = n1.n_nationkey
INNER JOIN orders o ON o.o_orderkey = l.l_orderkey
INNER JOIN customer c ON c.c_custkey = o.o_custkey
INNER JOIN nation n2 ON c.c_nationkey = n2.n_nationkey
WHERE l.l_shipdate BETWEEN date '1995-01-01' AND date '1996-12-31'
  AND ((n1.n_name = 'FRANCE'
        AND n2.n_name = 'GERMANY')
       OR (n1.n_name = 'GERMANY'
           AND n2.n_name = 'FRANCE'))
GROUP BY n1.n_name,
         n2.n_name,
         extract(YEAR
                 FROM l_shipdate)
ORDER BY supp_nation,
         cust_nation,
         l_year;