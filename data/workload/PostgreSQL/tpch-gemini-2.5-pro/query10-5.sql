WITH o AS
  (SELECT o_orderkey,
          o_custkey
   FROM orders
   WHERE o_orderdate >= date '1993-10-01'
     AND o_orderdate < date '1993-10-01' + interval '3' MONTH)
SELECT c_custkey,
       c_name,
       sum(l_extendedprice * (1 - l_discount)) AS revenue,
       c_acctbal,
       n_name,
       c_address,
       c_phone,
       c_comment
FROM customer
JOIN o ON c_custkey = o.o_custkey
JOIN lineitem ON l_orderkey = o.o_orderkey
JOIN nation ON c_nationkey = n_nationkey
WHERE l_returnflag = 'R'
GROUP BY c_custkey,
         c_name,
         c_acctbal,
         c_phone,
         n_name,
         c_address,
         c_comment
ORDER BY revenue DESC
LIMIT 20;