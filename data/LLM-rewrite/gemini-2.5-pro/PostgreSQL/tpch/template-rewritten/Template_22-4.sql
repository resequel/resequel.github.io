
SELECT sum(l_extendedprice * l_discount) AS revenue
FROM
  (SELECT l_extendedprice,
          l_discount
   FROM lineitem
   CROSS JOIN
     (SELECT date &&&_B + interval &&&_C YEAR AS end_date, ^^^_A - ^^^_B AS min_disc, ^^^_C + ^^^_D AS max_disc) b
   WHERE l_shipdate >= date &&&_A
     AND l_shipdate < b.end_date
     AND l_discount BETWEEN b.min_disc AND b.max_disc
     AND l_quantity < ###_A) sub;