WITH p AS
  (SELECT p_partkey
   FROM part
   WHERE p_name LIKE &&&_A),
     sn AS
  (SELECT s_suppkey,
          n_name AS nation
   FROM supplier
   JOIN nation ON s_nationkey = n_nationkey),
     o AS
  (SELECT o_orderkey,
          extract(YEAR
                  FROM o_orderdate) AS o_year
   FROM orders)
SELECT sn.nation,
       o.o_year,
       sum(l.l_extendedprice * (###_A - l.l_discount) - ps.ps_supplycost * l.l_quantity) AS sum_profit
FROM p
JOIN lineitem l ON p.p_partkey = l.l_partkey
JOIN partsupp ps ON l.l_partkey = ps.ps_partkey
AND l.l_suppkey = ps.ps_suppkey
JOIN sn ON l.l_suppkey = sn.s_suppkey
JOIN o ON l.l_orderkey = o.o_orderkey
GROUP BY sn.nation,
         o.o_year
ORDER BY sn.nation,
         o.o_year DESC;