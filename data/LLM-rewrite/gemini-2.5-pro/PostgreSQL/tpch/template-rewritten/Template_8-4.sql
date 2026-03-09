WITH nr AS
  (SELECT n_nationkey,
          n_name
   FROM nation
   JOIN region ON n_regionkey = r_regionkey
   WHERE r_name = &&&_A)
SELECT nr.n_name,
       sum(l.l_extendedprice * (###_A - l.l_discount)) AS revenue
FROM nr
JOIN supplier s ON s.s_nationkey = nr.n_nationkey
JOIN lineitem l ON s.s_suppkey = l.l_suppkey
JOIN
  (SELECT o_orderkey,
          o_custkey
   FROM orders
   WHERE o_orderdate >= date &&&_B
     AND o_orderdate < date &&&_C + interval &&&_D YEAR) o ON l.l_orderkey = o.o_orderkey
JOIN customer c ON o.o_custkey = c.c_custkey
AND c.c_nationkey = nr.n_nationkey
GROUP BY nr.n_name
ORDER BY revenue DESC;