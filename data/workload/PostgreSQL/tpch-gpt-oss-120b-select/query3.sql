WITH date_filter AS
  (SELECT o_orderkey,
          o_orderdate,
          o_shippriority,
          o_custkey
   FROM orders
   WHERE o_orderdate < DATE '1995-03-15'),
     ship_filter AS
  (SELECT l_orderkey,
          l_extendedprice,
          l_discount
   FROM lineitem
   WHERE l_shipdate > DATE '1995-03-15')
SELECT sf.l_orderkey,
       SUM(sf.l_extendedprice * (1 - sf.l_discount)) AS revenue,
       df.o_orderdate,
       df.o_shippriority
FROM ship_filter sf
JOIN date_filter df ON sf.l_orderkey = df.o_orderkey
JOIN customer c ON c.c_custkey = df.o_custkey
WHERE c.c_mktsegment = 'BUILDING' GROUP  BY sf.l_orderkey,
                                     df.o_orderdate,
                                     df.o_shippriority
  ORDER  BY revenue DESC,
            df.o_orderdate
LIMIT 10;