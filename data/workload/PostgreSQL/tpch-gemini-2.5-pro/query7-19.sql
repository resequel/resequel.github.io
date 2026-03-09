WITH l_filtered AS
  (SELECT l_orderkey,
          l_suppkey,
          extract(YEAR
                  FROM l_shipdate) AS l_year,
          l_extendedprice * (1 - l_discount) AS volume
   FROM lineitem
   WHERE l_shipdate BETWEEN date '1995-01-01' AND date '1996-12-31')
SELECT n1.n_name AS supp_nation,
       n2.n_name AS cust_nation,
       l.l_year,
       sum(l.volume) AS revenue
FROM l_filtered l
JOIN supplier s ON s.s_suppkey = l.l_suppkey
JOIN nation n1 ON s.s_nationkey = n1.n_nationkey
JOIN orders o ON l.l_orderkey = o.o_orderkey
JOIN customer c ON o.o_custkey = c.c_custkey
JOIN nation n2 ON c.c_nationkey = n2.n_nationkey
WHERE ((n1.n_name = 'FRANCE'
        AND n2.n_name = 'GERMANY')
       OR (n1.n_name = 'GERMANY'
           AND n2.n_name = 'FRANCE'))
GROUP BY n1.n_name,
         n2.n_name,
         l.l_year
ORDER BY supp_nation,
         cust_nation,
         l_year;