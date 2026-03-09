
SELECT sum(l.l_extendedprice * l.l_discount) AS revenue
FROM lineitem l
CROSS JOIN
  (SELECT date '1994-01-01' + interval '1' YEAR AS end_date, 0.06 - 0.01 AS min_disc, 0.06 + 0.01 AS max_disc) b
WHERE l.l_shipdate >= date '1994-01-01'
  AND l.l_shipdate < b.end_date
  AND l.l_discount >= b.min_disc
  AND l.l_discount <= b.max_disc
  AND l.l_quantity < 24;