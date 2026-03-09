
SELECT sum(l_extendedprice * l_discount) AS revenue
FROM lineitem
WHERE l_quantity < ###_A
  AND l_shipdate >= date &&&_A
  AND l_shipdate < date &&&_B + interval &&&_C YEAR
  AND l_discount BETWEEN ^^^_A - ^^^_B AND ^^^_C + ^^^_D;