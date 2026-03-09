
SELECT n1.n_name AS supp_nation,
       n2.n_name AS cust_nation,
       extract(YEAR
               FROM l.l_shipdate) AS l_year,
       sum(l.l_extendedprice * (###_A - l.l_discount)) AS revenue
FROM
  (SELECT l_orderkey,
          l_suppkey,
          l_shipdate,
          l_extendedprice,
          l_discount
   FROM lineitem
   WHERE l_shipdate BETWEEN date &&&_E AND date &&&_F) l
JOIN supplier s ON s.s_suppkey = l.l_suppkey
JOIN nation n1 ON s.s_nationkey = n1.n_nationkey
JOIN orders o ON l.l_orderkey = o.o_orderkey
JOIN customer c ON o.o_custkey = c.c_custkey
JOIN nation n2 ON c.c_nationkey = n2.n_nationkey
WHERE ((n1.n_name = &&&_A
        AND n2.n_name = &&&_B)
       OR (n1.n_name = &&&_C
           AND n2.n_name = &&&_D))
GROUP BY n1.n_name,
         n2.n_name,
         extract(YEAR
                 FROM l.l_shipdate)
ORDER BY supp_nation,
         cust_nation,
         l_year;