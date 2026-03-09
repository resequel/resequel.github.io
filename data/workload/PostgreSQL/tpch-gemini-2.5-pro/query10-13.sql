WITH rev_agg AS
  (SELECT o.o_custkey,
          sum(l.l_extendedprice * (1 - l.l_discount)) AS revenue
   FROM
     (SELECT o_orderkey,
             o_custkey
      FROM orders
      WHERE o_orderdate >= date '1993-10-01'
        AND o_orderdate < date '1993-10-01' + interval '3' MONTH) o
   JOIN
     (SELECT l_orderkey,
             l_extendedprice,
             l_discount
      FROM lineitem
      WHERE l_returnflag = 'R') l ON o.o_orderkey = l.l_orderkey
   GROUP BY o.o_custkey)
SELECT c.c_custkey,
       c.c_name,
       r.revenue,
       c.c_acctbal,
       n.n_name,
       c.c_address,
       c.c_phone,
       c.c_comment
FROM rev_agg r
JOIN customer c ON r.o_custkey = c.c_custkey
JOIN nation n ON c.c_nationkey = n.n_nationkey
ORDER BY r.revenue DESC
LIMIT 20;