
SELECT 100.0 * promo_sum / total_sum AS promo_revenue
FROM
  (SELECT SUM(l.l_extendedprice * (1 - l.l_discount)) FILTER (
                                                              WHERE p.p_type LIKE 'PROMO%') AS promo_sum,
          SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sum
   FROM lineitem l
   JOIN part p ON l.l_partkey = p.p_partkey
   WHERE l.l_shipdate >= DATE '1995-09-01'
     AND l.l_shipdate < (DATE '1995-09-01' + interval '1' MONTH)) sub;