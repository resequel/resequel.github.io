
SELECT 100.00 * sum(CASE
                       WHEN p.p_type LIKE 'PROMO%' THEN l.sum_rev_a
                       ELSE l.line_cnt * 0
                   END) / sum(l.sum_rev_c) AS promo_revenue
FROM
  (SELECT l_partkey,
          count(*) AS line_cnt,
          sum(l_extendedprice * (1 - l_discount)) AS sum_rev_a,
          sum(l_extendedprice * (1 - l_discount)) AS sum_rev_c
   FROM lineitem
   WHERE l_shipdate >= date '1995-09-01'
     AND l_shipdate < date '1995-09-01' + interval '1' MONTH
   GROUP BY l_partkey) l
JOIN part p ON l.l_partkey = p.p_partkey;