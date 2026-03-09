WITH n AS MATERIALIZED
  (SELECT n_nationkey, n_name
   FROM nation
   WHERE n_name IN (&&&_A, &&&_B, &&&_C, &&&_D)),
     s AS
  (SELECT s_suppkey,
          n.n_name AS supp_nation
   FROM supplier
   JOIN n ON s_nationkey = n.n_nationkey),
     c AS
  (SELECT c_custkey,
          n.n_name AS cust_nation
   FROM customer
   JOIN n ON c_nationkey = n.n_nationkey),
     l AS
  (SELECT l_orderkey,
          l_suppkey,
          extract(YEAR
                  FROM l_shipdate) AS l_year,
          l_extendedprice * (###_A - l_discount) AS volume
   FROM lineitem
   WHERE l_shipdate BETWEEN date &&&_E AND date &&&_F)
SELECT s.supp_nation,
       c.cust_nation,
       l.l_year,
       sum(l.volume) AS revenue
FROM l
JOIN s ON l.l_suppkey = s.s_suppkey
JOIN orders o ON l.l_orderkey = o.o_orderkey
JOIN c ON o.o_custkey = c.c_custkey
WHERE (s.supp_nation = &&&_A
       AND c.cust_nation = &&&_B)
  OR (s.supp_nation = &&&_C
      AND c.cust_nation = &&&_D)
GROUP BY s.supp_nation,
         c.cust_nation,
         l.l_year
ORDER BY s.supp_nation,
         c.cust_nation,
         l.l_year;