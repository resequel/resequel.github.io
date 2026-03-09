
SELECT ^^^_A * sum(CASE
                       WHEN p.p_type LIKE &&&_A THEN lat.rev_a
                       ELSE ###_B
                   END) / sum(lat.rev_c) AS promo_revenue
FROM lineitem l
JOIN part p ON l.l_partkey = p.p_partkey
CROSS JOIN LATERAL
  (SELECT l.l_extendedprice * (###_A - l.l_discount) AS rev_a,
          l.l_extendedprice * (###_C - l_discount) AS rev_c) lat
WHERE l.l_shipdate >= date &&&_B
  AND l.l_shipdate < date &&&_C + interval &&&_D MONTH;