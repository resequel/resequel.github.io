
SELECT l_returnflag,
       l_linestatus,
       sum(l_quantity) AS sum_qty,
       sum(l_extendedprice) AS sum_base_price,
       sum(disc_price) AS sum_disc_price,
       sum(disc_price * (###_C + l_tax)) AS sum_charge,
       sum_qty/count_order AS avg_qty,
       sum_base_price/count_order AS avg_price,
       sum_disc/count_order AS avg_disc,
       count_order
FROM
  (SELECT l_returnflag,
          l_linestatus,
          sum(l_quantity) AS sum_qty,
          sum(l_extendedprice) AS sum_base_price,
          sum(l_discount) AS sum_disc,
          sum(l_extendedprice * (###_A - l_discount)) AS disc_price,
          l_tax,
          count(*) AS count_order
   FROM lineitem
   WHERE l_shipdate <= date &&&_A - interval &&&_B DAY
   GROUP BY l_returnflag,
            l_linestatus,
            l_tax,
            l_extendedprice,
            l_discount) calc
GROUP BY l_returnflag,
         l_linestatus,
         sum_qty,
         sum_base_price,
         sum_disc,
         count_order
ORDER BY l_returnflag,
         l_linestatus;