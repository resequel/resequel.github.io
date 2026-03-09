WITH bounds AS
  (SELECT date '1994-01-01' + interval '1' YEAR AS end_date, 0.06 - 0.01 AS min_disc, 0.06 + 0.01 AS max_disc)
SELECT sum(l_extendedprice * l_discount) AS revenue
FROM lineitem
CROSS JOIN bounds b
WHERE l_shipdate >= date '1994-01-01'
  AND l_shipdate < b.end_date
  AND l_discount >= b.min_disc
  AND l_discount <= b.max_disc
  AND l_quantity < 24;