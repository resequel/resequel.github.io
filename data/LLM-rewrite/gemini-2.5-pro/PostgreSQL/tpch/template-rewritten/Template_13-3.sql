
SELECT o_year,
       sum(CASE
               WHEN nation = &&&_A THEN volume
               ELSE ###_A
           END) / sum(volume) AS mkt_share
FROM
  (SELECT extract(YEAR
                  FROM o.o_orderdate) AS o_year,
          l.l_extendedprice * (###_B - l.l_discount) AS volume,
          sn.nation
   FROM
     (SELECT p_partkey
      FROM part
      WHERE p_type = &&&_E) p
   JOIN lineitem l ON p.p_partkey = l.l_partkey
   JOIN
     (SELECT o_orderkey,
             o_custkey,
             o_orderdate
      FROM orders
      WHERE o_orderdate BETWEEN date &&&_C AND date &&&_D) o ON l.l_orderkey = o.o_orderkey
   JOIN
     (SELECT c_custkey
      FROM customer c
      JOIN nation n1 ON c.c_nationkey = n1.n_nationkey
      JOIN region r ON n1.n_regionkey = r.r_regionkey
      WHERE r.r_name = &&&_B) cr ON o.o_custkey = cr.c_custkey
   JOIN
     (SELECT s_suppkey,
             n2.n_name AS nation
      FROM supplier s
      JOIN nation n2 ON s.s_nationkey = n2.n_nationkey) sn ON l.l_suppkey = sn.s_suppkey) AS all_nations
GROUP BY o_year
ORDER BY o_year;