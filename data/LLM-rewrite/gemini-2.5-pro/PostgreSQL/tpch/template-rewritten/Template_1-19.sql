WITH d AS
  (SELECT date &&&_B AS s, date &&&_C + interval &&&_D MONTH AS e)
SELECT ^^^_A * sum(CASE
                       WHEN p.p_type LIKE &&&_A THEN c.ra
                       ELSE ###_B
                   END) / sum(c.rc) AS promo_revenue
FROM lineitem l
JOIN d ON l.l_shipdate >= d.s
AND l.l_shipdate < d.e
JOIN part p ON l.l_partkey = p.p_partkey
CROSS JOIN LATERAL
  (SELECT l.l_extendedprice * (###_A - l.l_discount) AS ra,
          l.l_extendedprice * (###_C - l.l_discount) AS rc) c;