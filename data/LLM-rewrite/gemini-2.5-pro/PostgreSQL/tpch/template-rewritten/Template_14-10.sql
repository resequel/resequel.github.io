
SELECT calc.l_returnflag,
       calc.l_linestatus,
       sum(calc.l_quantity) AS sum_qty,
       sum(calc.l_extendedprice) AS sum_base_price,
       sum(calc.disc) AS sum_disc_price,
       sum(calc.charge) AS sum_charge,
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
          l_extendedprice * (###_A - l_discount) AS disc,
          l_extendedprice * (###_B - l_discount) * (###_C + l_tax) AS charge
   FROM lineitem
   WHERE l_shipdate <= date &&&_A - interval &&&_B DAY) calc
GROUP BY calc.l_returnflag,
         calc.l_linestatus
ORDER BY calc.l_returnflag,
         calc.l_linestatus;