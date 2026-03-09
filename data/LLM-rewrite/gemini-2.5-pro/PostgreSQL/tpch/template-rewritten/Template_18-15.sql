WITH revenue (supplier_no, total_revenue) AS
  (SELECT l_suppkey,
          sum(l_extendedprice * (###_A - l_discount))
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
WHERE total_revenue =
    (SELECT max(total_revenue)
     FROM revenue)
  AND s_suppkey = supplier_no
ORDER BY s_suppkey;