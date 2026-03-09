
SELECT l_returnflag,
       l_linestatus,
       sum(l_quantity) AS sum_qty,
       sum(l_extendedprice) AS sum_base_price,
       sum(disc_price) AS sum_disc_price,
       sum(charge_price) AS sum_charge,
       avg(l_quantity) AS avg_qty,
       avg(l_extendedprice) AS avg_price,
       avg(l_discount) AS avg_disc,
       count(*) AS count_order
FROM
  (SELECT l_returnflag,
          l_linestatus,
          l_quantity,
          l_extendedprice,
          l_discount,
          l_extendedprice * (###_A - l_discount) AS disc_price,
          (l_extendedprice * (###_B - l_discount) * (###_C + l_tax)) AS charge_price
   FROM lineitem
   WHERE l_shipdate <= date &&&_A - interval &&&_B DAY) calc
GROUP BY l_returnflag,
         l_linestatus
ORDER BY l_returnflag,
         l_linestatus;