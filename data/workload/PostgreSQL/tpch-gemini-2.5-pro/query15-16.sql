WITH revenue (supplier_no, total_revenue) AS
  (SELECT l_suppkey,
          sum(l_extendedprice * (1 - l_discount))
   FROM lineitem
   WHERE l_shipdate >= date '1996-01-01'
     AND l_shipdate < date '1996-01-01' + interval '3' MONTH
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