WITH revenue AS
  (SELECT l_suppkey AS supplier_no,
          sum(l_extendedprice * (###_A - l_discount)) AS total_revenue
   FROM lineitem
   WHERE l_shipdate >= date &&&_A
     AND l_shipdate < date &&&_B + interval &&&_C MONTH
   GROUP BY l_suppkey)
SELECT s.s_suppkey,
       s.s_name,
       s.s_address,
       s.s_phone,
       r.total_revenue
FROM supplier s
JOIN revenue r ON s.s_suppkey = r.supplier_no
ORDER BY r.total_revenue DESC FETCH FIRST 1 ROW WITH TIES;