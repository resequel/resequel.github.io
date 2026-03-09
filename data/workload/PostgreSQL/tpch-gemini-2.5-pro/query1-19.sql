WITH calc AS
  (SELECT l_returnflag,
          l_linestatus,
          l_quantity,
          l_extendedprice,
          l_discount,
          l_tax,
          l_extendedprice * (1 - l_discount) AS disc_price
   FROM lineitem
   WHERE l_shipdate <= date '1998-12-01' - interval '90' DAY)
SELECT l_returnflag,
       l_linestatus,
       sum(l_quantity) AS sum_qty,
       sum(l_extendedprice) AS sum_base_price,
       sum(disc_price) AS sum_disc_price,
       sum(disc_price * (1 + l_tax)) AS sum_charge,
       sum(l_quantity)/count(*) AS avg_qty,
       sum(l_extendedprice)/count(*) AS avg_price,
       sum(l_discount)/count(*) AS avg_disc,
       count(*) AS count_order
FROM calc
GROUP BY l_returnflag,
         l_linestatus
ORDER BY l_returnflag,
         l_linestatus;