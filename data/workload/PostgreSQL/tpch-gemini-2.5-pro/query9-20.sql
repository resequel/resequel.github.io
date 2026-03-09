
SELECT sn.nation,
       o.o_year,
       sum(l.l_extendedprice * (1 - l.l_discount) - ps.ps_supplycost * l.l_quantity) AS sum_profit
FROM
  (SELECT p_partkey
   FROM part
   WHERE p_name LIKE '%green%') p
JOIN lineitem l ON p.p_partkey = l.l_partkey
JOIN partsupp ps ON l.l_partkey = ps.ps_partkey
AND l.l_suppkey = ps.ps_suppkey
JOIN
  (SELECT s_suppkey,
          n_name AS nation
   FROM supplier
   JOIN nation ON s_nationkey = n_nationkey) sn ON l.l_suppkey = sn.s_suppkey
JOIN
  (SELECT o_orderkey,
          extract(YEAR
                  FROM o_orderdate) AS o_year
   FROM orders) o ON l.l_orderkey = o.o_orderkey
GROUP BY sn.nation,
         o.o_year
ORDER BY sn.nation,
         o_year DESC;