
SELECT c_custkey,
       c_name,
       sum(l.l_extendedprice * (###_A - l.l_discount)) AS revenue,
       c_acctbal,
       n_name,
       c_address,
       c_phone,
       c_comment
FROM customer
JOIN orders o ON c_custkey = o.o_custkey
JOIN
  (SELECT l_orderkey,
          l_extendedprice,
          l_discount
   FROM lineitem
   WHERE l_returnflag = &&&_D) l ON l.l_orderkey = o.o_orderkey
JOIN nation ON c_nationkey = n_nationkey
WHERE o.o_orderdate >= date &&&_A
  AND o.o_orderdate < date &&&_B + interval &&&_C MONTH
GROUP BY c_custkey,
         c_name,
         c_acctbal,
         c_phone,
         n_name,
         c_address,
         c_comment
ORDER BY revenue DESC
LIMIT ###_B;