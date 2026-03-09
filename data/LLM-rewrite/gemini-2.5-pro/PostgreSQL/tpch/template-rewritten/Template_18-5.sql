WITH revenue AS MATERIALIZED
  (SELECT l_suppkey AS supplier_no, sum(l_extendedprice * (###_A - l_discount)) AS total_revenue
   FROM lineitem
   WHERE l_shipdate >= date &&&_A
     AND l_shipdate < date &&&_B + interval &&&_C MONTH
   GROUP BY l_suppkey),
     max_rev AS
  (SELECT max(total_revenue) AS max_total
   FROM revenue)
SELECT s.s_suppkey,
       s.s_name,
       s.s_address,
       s.s_phone,
       r.total_revenue
FROM supplier s
JOIN revenue r ON s.s_suppkey = r.supplier_no
CROSS JOIN max_rev m
WHERE r.total_revenue = m.max_total
ORDER BY s.s_suppkey;