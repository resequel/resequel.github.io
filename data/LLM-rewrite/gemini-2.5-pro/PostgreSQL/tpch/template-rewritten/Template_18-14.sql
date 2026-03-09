WITH revenue AS
  (SELECT l_suppkey AS supplier_no,
          sum(l_extendedprice * (###_A - l_discount)) AS total_revenue
   FROM lineitem
   WHERE l_shipdate >= date &&&_A
     AND l_shipdate < date &&&_B + interval &&&_C MONTH
   GROUP BY l_suppkey)
SELECT s_suppkey,
       s_name,
       s_address,
       s_phone,
       total_revenue
FROM supplier,
     revenue
WHERE s_suppkey = supplier_no
  AND total_revenue =
    (SELECT max(total_revenue)
     FROM revenue)
ORDER BY s_suppkey;