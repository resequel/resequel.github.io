
SELECT s.s_suppkey,
       s.s_name,
       s.s_address,
       s.s_phone,
       r.total_revenue
FROM supplier s
INNER JOIN
  (SELECT l_suppkey AS supplier_no,
          sum(l_extendedprice * (###_A - l_discount)) AS total_revenue
   FROM lineitem
   WHERE l_shipdate >= date &&&_A
     AND l_shipdate < date &&&_B + interval &&&_C MONTH
   GROUP BY l_suppkey) r ON s.s_suppkey = r.supplier_no
WHERE r.total_revenue =
    (SELECT max(total_revenue)
     FROM
       (SELECT sum(l_extendedprice * (###_A - l_discount)) AS total_revenue
        FROM lineitem
        WHERE l_shipdate >= date &&&_A
          AND l_shipdate < date &&&_B + interval &&&_C MONTH
        GROUP BY l_suppkey) r2)
ORDER BY s.s_suppkey;