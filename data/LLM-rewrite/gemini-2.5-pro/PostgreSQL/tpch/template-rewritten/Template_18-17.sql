WITH revenue (supplier_no, total_revenue) AS
  (SELECT l_suppkey,
          sum(l_extendedprice * (###_A - l_discount))
   FROM lineitem
   WHERE l_shipdate >= date &&&_A
     AND l_shipdate < date &&&_B + interval &&&_C MONTH
   GROUP BY l_suppkey)
SELECT supplier.s_suppkey,
       supplier.s_name,
       supplier.s_address,
       supplier.s_phone,
       revenue.total_revenue
FROM supplier,
     revenue
WHERE supplier.s_suppkey = revenue.supplier_no
  AND revenue.total_revenue =
    (SELECT max(total_revenue)
     FROM revenue)
ORDER BY supplier.s_suppkey;