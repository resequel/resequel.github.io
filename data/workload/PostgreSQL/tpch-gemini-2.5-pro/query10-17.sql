
SELECT c.c_custkey,
       c.c_name,
       sum(l.l_extendedprice * (1 - l.l_discount)) AS revenue,
       c.c_acctbal,
       n.n_name,
       c.c_address,
       c.c_phone,
       c.c_comment
FROM orders o
INNER JOIN lineitem l ON o.o_orderkey = l.l_orderkey
INNER JOIN customer c ON o.o_custkey = c.c_custkey
INNER JOIN nation n ON c.c_nationkey = n.n_nationkey
WHERE o.o_orderdate >= date '1993-10-01'
  AND o.o_orderdate < date '1993-10-01' + interval '3' MONTH
  AND l.l_returnflag = 'R'
GROUP BY c.c_custkey,
         c.c_name,
         c.c_acctbal,
         c.c_phone,
         n.n_name,
         c.c_address,
         c.c_comment
ORDER BY revenue DESC
LIMIT 20;