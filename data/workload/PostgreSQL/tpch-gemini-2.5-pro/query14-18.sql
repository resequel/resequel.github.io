
SELECT 100.00 * sum(CASE
                       WHEN p.p_type LIKE 'PROMO%' THEN l.l_extendedprice * (1 - l.l_discount)
                       ELSE 0
                   END) / sum(l.l_extendedprice * (1 - l.l_discount)) AS promo_revenue
FROM part p
JOIN lineitem l ON p.p_partkey = l.l_partkey
WHERE l.l_shipdate >= date '1995-09-01'
  AND l.l_shipdate < date '1995-09-01' + interval '1' MONTH;