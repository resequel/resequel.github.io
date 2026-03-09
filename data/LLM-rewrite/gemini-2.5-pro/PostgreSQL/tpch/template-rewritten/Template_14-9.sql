
SELECT calc.l_returnflag,
       calc.l_linestatus,
       sum(calc.l_quantity) AS sum_qty,
       sum(calc.l_extendedprice) AS sum_base_price,
       sum(calc.l_extendedprice * (###_A - calc.l_discount)) AS sum_disc_price,
       sum(calc.l_extendedprice * (###_B - calc.l_discount) * (###_C + calc.l_tax)) AS sum_charge,
       sum(calc.l_quantity)/count(*) AS avg_qty,
       sum(calc.l_extendedprice)/count(*) AS avg_price,
       sum(calc.l_discount)/count(*) AS avg_disc,
       count(*) AS count_order
FROM
  (SELECT l_returnflag,
          l_linestatus,
          l_quantity,
          l_extendedprice,
          l_discount,
          l_tax
   FROM lineitem
   WHERE l_shipdate <= date &&&_A - interval &&&_B DAY) calc
GROUP BY calc.l_returnflag,
         calc.l_linestatus
ORDER BY calc.l_returnflag,
         calc.l_linestatus;