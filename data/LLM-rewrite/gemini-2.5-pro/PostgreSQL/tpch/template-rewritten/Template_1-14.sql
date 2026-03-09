
SELECT ^^^_A * sum(CASE
                       WHEN p.p_type LIKE &&&_A THEN l.sum_rev_a
                       ELSE l.line_cnt * ###_B
                   END) / sum(l.sum_rev_c) AS promo_revenue
FROM
  (SELECT l_partkey,
          count(*) AS line_cnt,
          sum(l_extendedprice * (###_A - l_discount)) AS sum_rev_a,
          sum(l_extendedprice * (###_C - l_discount)) AS sum_rev_c
   FROM lineitem
   WHERE l_shipdate >= date &&&_B
     AND l_shipdate < date &&&_C + interval &&&_D MONTH
   GROUP BY l_partkey) l
JOIN
  (SELECT p_partkey,
          p_type
   FROM part) p ON l.l_partkey = p.p_partkey;