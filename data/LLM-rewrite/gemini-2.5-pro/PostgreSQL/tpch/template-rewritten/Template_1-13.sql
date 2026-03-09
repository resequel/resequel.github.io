
SELECT ^^^_A * sum(CASE
                       WHEN p.p_type LIKE &&&_A THEN l.l_extendedprice * (###_A - l.l_discount)
                       ELSE ###_B
                   END) / sum(l.l_extendedprice * (###_C - l.l_discount)) AS promo_revenue
FROM part p
JOIN lineitem l ON p.p_partkey = l.l_partkey
WHERE l.l_shipdate >= date &&&_B
  AND l.l_shipdate < date &&&_C + interval &&&_D MONTH;