
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
   FROM supplier s,
        lineitem l,
        orders o,
        customer c,
        nation n1,
        nation n2
   WHERE s.s_suppkey = l.l_suppkey
     AND o.o_orderkey = l.l_orderkey
     AND c.c_custkey = o.o_custkey
     AND s.s_nationkey = n1.n_nationkey
     AND c.c_nationkey = n2.n_nationkey
     AND l.l_shipdate BETWEEN date &&&_E AND date &&&_F
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