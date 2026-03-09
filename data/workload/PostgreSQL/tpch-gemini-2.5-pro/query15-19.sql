WITH revenue (supplier_no, total_revenue) AS
  (SELECT l_suppkey,
          sum(l_extendedprice * (1 - l_discount))
   FROM lineitem
   WHERE l_shipdate >= date '1996-01-01'
     AND l_shipdate < date '1996-01-01' + interval '3' MONTH
   GROUP BY l_suppkey)
SELECT s.s_suppkey,
       s.s_name,
       s.s_address,
       s.s_phone,
       r.total_revenue
FROM revenue r,
     supplier s
WHERE s.s_suppkey = r.supplier_no
  AND r.total_revenue =
    (SELECT max(total_revenue)
     FROM revenue)
ORDER BY s.s_suppkey;