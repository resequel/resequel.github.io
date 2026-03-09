WITH revenue AS
  (SELECT l_suppkey AS s_suppkey,
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
JOIN revenue r USING (s_suppkey)
WHERE r.total_revenue =
    (SELECT max(total_revenue)
     FROM revenue)
ORDER BY s.s_suppkey;