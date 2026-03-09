WITH dates AS
  (SELECT date '1995-09-01' AS start_date, date '1995-09-01' + interval '1' MONTH AS end_date),
     l AS
  (SELECT l_partkey,
          count(*) AS line_cnt,
          sum(l_extendedprice * (1 - l_discount)) AS sum_rev_a,
          sum(l_extendedprice * (1 - l_discount)) AS sum_rev_c
   FROM lineitem
   CROSS JOIN dates
   WHERE l_shipdate >= dates.start_date
     AND l_shipdate < dates.end_date
   GROUP BY l_partkey)
SELECT 100.00 * sum(CASE
                       WHEN p.p_type LIKE 'PROMO%' THEN l.sum_rev_a
                       ELSE l.line_cnt * 0
                   END) / sum(l.sum_rev_c) AS promo_revenue
FROM l
JOIN part p ON l.l_partkey = p.p_partkey;