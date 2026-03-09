WITH shipdate_hash AS
  (SELECT l_returnflag,
          l_linestatus,
          l_quantity,
          l_extendedprice,
          l_discount,
          l_tax
   FROM lineitem
   WHERE l_shipdate <= CAST('1998-12-01' AS DATE) - INTERVAL '90' DAY)
SELECT h.l_returnflag,
       h.l_linestatus,
       SUM(h.l_quantity) AS sum_qty,
       SUM(h.l_extendedprice) AS sum_base_price,
       SUM(h.l_extendedprice * (1 - h.l_discount)) AS sum_disc_price,
       SUM(h.l_extendedprice * (1 - h.l_discount) * (1 + h.l_tax)) AS sum_charge,
       AVG(h.l_quantity) AS avg_qty,
       AVG(h.l_extendedprice) AS avg_price,
       AVG(h.l_discount) AS avg_disc,
       COUNT(*) AS count_order
FROM shipdate_hash h
GROUP BY h.l_returnflag,
         h.l_linestatus
ORDER BY h.l_returnflag,
         h.l_linestatus;