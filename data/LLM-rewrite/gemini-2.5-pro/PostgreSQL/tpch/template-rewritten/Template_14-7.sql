
SELECT l_returnflag,
       l_linestatus,
       sum(l_quantity) AS sum_qty,
       sum(l_extendedprice) AS sum_base_price,
       sum(l_extendedprice * (###_A - l_discount)) AS sum_disc_price,
       sum(l_extendedprice * (###_B - l_discount) * (###_C + l_tax)) AS sum_charge,
       sum(l_quantity)/count(*) AS avg_qty,
       sum(l_extendedprice)/count(*) AS avg_price,
       sum(l_discount)/count(*) AS avg_disc,
       count(*) AS count_order
FROM lineitem
WHERE l_shipdate <= date &&&_A - interval &&&_B DAY
GROUP BY l_returnflag,
         l_linestatus
ORDER BY l_returnflag,
         l_linestatus;