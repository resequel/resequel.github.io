WITH revenue (supplier_no, total_revenue) AS
  (SELECT l_suppkey,
          sum(l_extendedprice * (1 - l_discount))
   FROM lineitem
   WHERE l_shipdate >= date '1996-01-01'
     AND l_shipdate < date '1996-01-01' + interval '3' MONTH
   GROUP BY l_suppkey)
SELECT s_suppkey,
       s_name,
       s_address,
       s_phone,
       total_revenue
FROM supplier s
JOIN revenue r ON s.s_suppkey = r.supplier_no
WHERE EXISTS
    (SELECT 1
     FROM
       (SELECT max(total_revenue) AS m_rev
        FROM revenue) mr
     WHERE r.total_revenue = mr.m_rev)
ORDER BY s_suppkey;