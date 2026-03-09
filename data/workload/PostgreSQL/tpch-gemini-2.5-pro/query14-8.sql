
SELECT 100.00 * sum(CASE
                       WHEN part.p_type LIKE 'PROMO%' THEN lineitem.l_extendedprice * (1 - lineitem.l_discount)
                       ELSE 0
                   END) / sum(lineitem.l_extendedprice * (1 - lineitem.l_discount)) AS promo_revenue
FROM lineitem
INNER JOIN part ON lineitem.l_partkey = part.p_partkey
WHERE lineitem.l_shipdate >= date '1995-09-01'
  AND lineitem.l_shipdate < date '1995-09-01' + interval '1' MONTH;