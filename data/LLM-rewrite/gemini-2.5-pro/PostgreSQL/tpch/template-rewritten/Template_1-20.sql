
SELECT ^^^_A * sum(CASE
                       WHEN part.p_type LIKE &&&_A THEN lineitem.l_extendedprice * (###_A - lineitem.l_discount)
                       ELSE ###_B
                   END) / sum(lineitem.l_extendedprice * (###_C - lineitem.l_discount)) AS promo_revenue
FROM lineitem
INNER JOIN part ON lineitem.l_partkey = part.p_partkey
WHERE lineitem.l_shipdate >= date &&&_B
  AND lineitem.l_shipdate < date &&&_C + interval &&&_D MONTH;