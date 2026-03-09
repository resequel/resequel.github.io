
SELECT supp_nation,
       cust_nation,
       l_year,
       sum(volume) AS revenue
FROM
  (SELECT sn.supp_nation,
          cn.cust_nation,
          l.l_year,
          l.volume
   FROM
     (SELECT l_orderkey,
             l_suppkey,
             extract(YEAR
                     FROM l_shipdate) AS l_year,
             l_extendedprice * (1 - l_discount) AS volume
      FROM lineitem
      WHERE l_shipdate BETWEEN date '1995-01-01' AND date '1996-12-31') l
   JOIN
     (SELECT s_suppkey,
             n_name AS supp_nation
      FROM supplier
      JOIN nation ON s_nationkey = n_nationkey
      WHERE n_name IN ('FRANCE', 'GERMANY')) sn ON l.l_suppkey = sn.s_suppkey
   JOIN orders o ON l.l_orderkey = o.o_orderkey
   JOIN
     (SELECT c_custkey,
             n_name AS cust_nation
      FROM customer
      JOIN nation ON c_nationkey = n_nationkey
      WHERE n_name IN ('GERMANY', 'FRANCE')) cn ON o.o_custkey = cn.c_custkey
   WHERE (sn.supp_nation = 'FRANCE'
          AND cn.cust_nation = 'GERMANY')
     OR (sn.supp_nation = 'GERMANY'
         AND cn.cust_nation = 'FRANCE')) AS shipping
GROUP BY supp_nation,
         cust_nation,
         l_year
ORDER BY supp_nation,
         cust_nation,
         l_year;