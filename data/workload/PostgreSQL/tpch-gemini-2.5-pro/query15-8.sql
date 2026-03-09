
SELECT s.s_suppkey,
       s.s_name,
       s.s_address,
       s.s_phone,
       r.total_revenue
FROM supplier s
JOIN
  (SELECT supplier_no,
          total_revenue,
          rank() OVER (
                       ORDER BY total_revenue DESC) AS rnk
   FROM
     (SELECT l_suppkey AS supplier_no,
             sum(l_extendedprice * (1 - l_discount)) AS total_revenue
      FROM lineitem
      WHERE l_shipdate >= date '1996-01-01'
        AND l_shipdate < date '1996-01-01' + interval '3' MONTH
      GROUP BY l_suppkey) rev) r ON s.s_suppkey = r.supplier_no
WHERE r.rnk = 1
ORDER BY s.s_suppkey;