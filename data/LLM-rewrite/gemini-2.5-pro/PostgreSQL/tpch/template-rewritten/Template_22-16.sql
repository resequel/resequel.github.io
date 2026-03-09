
SELECT sum(l_extendedprice * l_discount) AS revenue
FROM lineitem
WHERE l_shipdate >= date &&&_A
  AND l_shipdate < date &&&_B + interval &&&_C YEAR
  AND l_discount >= ^^^_A - ^^^_B
  AND l_discount <= ^^^_C + ^^^_D
  AND l_quantity < ###_A;