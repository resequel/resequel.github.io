
SELECT supp_nation,
       cust_nation,
       l_year,
       sum(volume) AS revenue
FROM
  (SELECT n1.n_name AS supp_nation,
          n2.n_name AS cust_nation,
          extract(YEAR
                  FROM l_shipdate) AS l_year,
          l_extendedprice * (###_A - l_discount) AS volume
   FROM nation n1
   INNER JOIN supplier s ON n1.n_nationkey = s.s_nationkey
   INNER JOIN lineitem l ON s.s_suppkey = l.l_suppkey
   INNER JOIN orders o ON l.l_orderkey = o.o_orderkey
   INNER JOIN customer c ON o.o_custkey = c.c_custkey
   INNER JOIN nation n2 ON c.c_nationkey = n2.n_nationkey
   WHERE l_shipdate BETWEEN date &&&_E AND date &&&_F
     AND ((n1.n_name = &&&_A
           AND n2.n_name = &&&_B)
          OR (n1.n_name = &&&_C
              AND n2.n_name = &&&_D))) AS shipping
GROUP BY supp_nation,
         cust_nation,
         l_year
ORDER BY supp_nation,
         cust_nation,
         l_year;