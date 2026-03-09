WITH calc AS
  (SELECT l_extendedprice * l_discount AS rev
   FROM lineitem
   WHERE l_discount BETWEEN ^^^_A - ^^^_B AND ^^^_C + ^^^_D
     AND l_quantity < ###_A
     AND l_shipdate >= date &&&_A
     AND l_shipdate < date &&&_B + interval &&&_C YEAR)
SELECT sum(rev) AS revenue
FROM calc;