
SELECT 100.00 * sum(CASE
                       WHEN p.p_type LIKE 'PROMO%' THEN lat.rev_a
                       ELSE 0
                   END) / sum(lat.rev_c) AS promo_revenue
FROM lineitem l
JOIN part p ON l.l_partkey = p.p_partkey
CROSS JOIN LATERAL
  (SELECT l.l_extendedprice * (1 - l.l_discount) AS rev_a,
          l.l_extendedprice * (1 - l_discount) AS rev_c) lat
WHERE l.l_shipdate >= date '1995-09-01'
  AND l.l_shipdate < date '1995-09-01' + interval '1' MONTH;