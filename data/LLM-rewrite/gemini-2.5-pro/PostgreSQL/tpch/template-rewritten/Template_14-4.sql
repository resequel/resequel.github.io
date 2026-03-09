WITH calc AS
  (SELECT l_returnflag,
          l_linestatus,
          l_quantity,
          l_extendedprice,
          l_discount,
          l_tax,
          l_extendedprice * (###_A - l_discount) AS disc_price
   FROM lineitem
   WHERE l_shipdate <= date &&&_A - interval &&&_B DAY)
SELECT l_returnflag,
       l_linestatus,
       sum(l_quantity) AS sum_qty,
       sum(l_extendedprice) AS sum_base_price,
       sum(disc_price) AS sum_disc_price,
       sum(disc_price * (###_C + l_tax)) AS sum_charge,
       avg(l_quantity) AS avg_qty,
       avg(l_extendedprice) AS avg_price,
       avg(l_discount) AS avg_disc,
       count(*) AS count_order
FROM calc
GROUP BY l_returnflag,
         l_linestatus
ORDER BY l_returnflag,
         l_linestatus;