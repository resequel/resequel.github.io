
SELECT sum(l_extendedprice * l_discount) AS revenue
FROM
  (SELECT l_extendedprice,
          l_discount
   FROM lineitem
   CROSS JOIN
     (SELECT date '1994-01-01' + interval '1' YEAR AS end_date, 0.06 - 0.01 AS min_disc, 0.06 + 0.01 AS max_disc) b
   WHERE l_shipdate >= date '1994-01-01'
     AND l_shipdate < b.end_date
     AND l_discount BETWEEN b.min_disc AND b.max_disc
     AND l_quantity < 24) sub;