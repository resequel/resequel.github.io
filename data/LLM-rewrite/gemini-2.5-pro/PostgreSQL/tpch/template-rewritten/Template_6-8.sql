WITH o_l AS
  (SELECT o.o_custkey,
          l.rev
   FROM
     (SELECT o_orderkey,
             o_custkey
      FROM orders
      WHERE o_orderdate >= date &&&_A
        AND o_orderdate < date &&&_B + interval &&&_C MONTH) o
   JOIN
     (SELECT l_orderkey,
             sum(l_extendedprice * (###_A - l_discount)) AS rev
      FROM lineitem
      WHERE l_returnflag = &&&_D
      GROUP BY l_orderkey) l ON o.o_orderkey = l.l_orderkey)
SELECT c.c_custkey,
       c.c_name,
       sum(ol.rev) AS revenue,
       c.c_acctbal,
       n.n_name,
       c.c_address,
       c.c_phone,
       c.c_comment
FROM customer c
JOIN o_l ol ON c.c_custkey = ol.o_custkey
JOIN nation n ON c.c_nationkey = n.n_nationkey
GROUP BY c.c_custkey,
         c.c_name,
         c.c_acctbal,
         c.c_phone,
         n.n_name,
         c.c_address,
         c.c_comment
ORDER BY revenue DESC
LIMIT ###_B;