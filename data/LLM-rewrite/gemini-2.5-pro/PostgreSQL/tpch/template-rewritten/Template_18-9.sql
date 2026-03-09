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
FROM supplier s
JOIN revenue r ON s.s_suppkey = r.supplier_no
AND r.total_revenue =
  (SELECT max(total_revenue)
   FROM revenue)
ORDER BY s_suppkey;