
SELECT 100.00 * sum(CASE
                       WHEN p.p_type LIKE 'PROMO%' THEN l.l_extendedprice * (1 - l.l_discount)
                       ELSE 0
                   END) / sum(l.l_extendedprice * (1 - l.l_discount)) AS promo_revenue
FROM
  (SELECT l_partkey,
          l_extendedprice,
          l_discount
   FROM lineitem
   WHERE l_shipdate >= date '1995-09-01'
     AND l_shipdate < (date '1995-09-01' + interval '1' MONTH)) l
JOIN part p ON l.l_partkey = p.p_partkey;