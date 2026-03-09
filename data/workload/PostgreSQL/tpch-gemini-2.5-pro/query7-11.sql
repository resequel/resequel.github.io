
SELECT supp_nation,
       cust_nation,
       l_year,
       sum(volume) AS revenue
FROM
  (SELECT n1.n_name AS supp_nation,
          n2.n_name AS cust_nation,
          extract(YEAR
                  FROM l_shipdate) AS l_year,
          l_extendedprice * (1 - l_discount) AS volume
   FROM lineitem l
   INNER JOIN orders o ON l.l_orderkey = o.o_orderkey
   INNER JOIN customer c ON o.o_custkey = c.c_custkey
   INNER JOIN nation n2 ON c.c_nationkey = n2.n_nationkey
   INNER JOIN supplier s ON l.l_suppkey = s.s_suppkey
   INNER JOIN nation n1 ON s.s_nationkey = n1.n_nationkey
   WHERE l_shipdate BETWEEN date '1995-01-01' AND date '1996-12-31'
     AND ((n1.n_name = 'FRANCE'
           AND n2.n_name = 'GERMANY')
          OR (n1.n_name = 'GERMANY'
              AND n2.n_name = 'FRANCE'))) AS shipping
GROUP BY supp_nation,
         cust_nation,
         l_year
ORDER BY supp_nation,
         cust_nation,
         l_year;