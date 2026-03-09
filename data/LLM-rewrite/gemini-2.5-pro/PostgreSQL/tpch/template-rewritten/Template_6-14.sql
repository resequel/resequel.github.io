WITH o AS
  (SELECT o_orderkey,
          o_custkey
   FROM orders
   WHERE o_orderdate >= date &&&_A
     AND o_orderdate < date &&&_B + interval &&&_C MONTH)
SELECT c_custkey,
       c_name,
       sum(l_extendedprice * (###_A - l_discount)) AS revenue,
       c_acctbal,
       n_name,
       c_address,
       c_phone,
       c_comment
FROM customer
JOIN o ON c_custkey = o.o_custkey
JOIN lineitem ON l_orderkey = o.o_orderkey
JOIN nation ON c_nationkey = n_nationkey
WHERE l_returnflag = &&&_D
GROUP BY c_custkey,
         c_name,
         c_acctbal,
         c_phone,
         n_name,
         c_address,
         c_comment
ORDER BY revenue DESC
LIMIT ###_B;