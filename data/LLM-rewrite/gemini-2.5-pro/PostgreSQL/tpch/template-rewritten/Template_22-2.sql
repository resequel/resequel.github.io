
SELECT sum(l.l_extendedprice * l.l_discount) AS revenue
FROM lineitem l
CROSS JOIN
  (SELECT date &&&_B + interval &&&_C YEAR AS end_date, ^^^_A - ^^^_B AS min_disc, ^^^_C + ^^^_D AS max_disc) b
WHERE l.l_shipdate >= date &&&_A
  AND l.l_shipdate < b.end_date
  AND l.l_discount >= b.min_disc
  AND l.l_discount <= b.max_disc
  AND l.l_quantity < ###_A;