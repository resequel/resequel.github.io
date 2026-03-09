SELECT l_returnflag,
       l_linestatus,
       sum(l_quantity) AS sum_qty,
       sum(l_extendedprice) AS sum_base_price,
       sum(l_extendedprice * (###_A - l_discount)) AS sum_disc_price,
       sum(l_extendedprice * (###_B - l_discount) * (###_C + l_tax)) AS sum_charge,
       avg(l_quantity) AS avg_qty,
       avg(l_extendedprice) AS avg_price,
       avg(l_discount) AS avg_disc,
       count(*) AS count_order
FROM lineitem
WHERE l_shipdate <= date &&&_A - interval &&&_B DAY
GROUP BY l_returnflag,
         l_linestatus
ORDER BY l_returnflag,
         l_linestatus;