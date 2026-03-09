WITH bounds AS MATERIALIZED
  (SELECT date &&&_B + interval &&&_C YEAR AS end_date, ^^^_A - ^^^_B AS min_disc, ^^^_C + ^^^_D AS max_disc)
SELECT sum(l_extendedprice * l_discount) AS revenue
FROM lineitem
CROSS JOIN bounds b
WHERE l_shipdate >= date &&&_A
  AND l_shipdate < b.end_date
  AND l_discount >= b.min_disc
  AND l_discount <= b.max_disc
  AND l_quantity < ###_A;