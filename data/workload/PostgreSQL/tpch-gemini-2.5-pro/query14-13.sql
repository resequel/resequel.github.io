WITH d AS
  (SELECT date '1995-09-01' AS s, date '1995-09-01' + interval '1' MONTH AS e)
SELECT 100.00 * sum(CASE
                       WHEN p.p_type LIKE 'PROMO%' THEN c.ra
                       ELSE 0
                   END) / sum(c.rc) AS promo_revenue
FROM lineitem l
JOIN d ON l.l_shipdate >= d.s
AND l.l_shipdate < d.e
JOIN part p ON l.l_partkey = p.p_partkey
CROSS JOIN LATERAL
  (SELECT l.l_extendedprice * (1 - l.l_discount) AS ra,
          l.l_extendedprice * (1 - l.l_discount) AS rc) c;