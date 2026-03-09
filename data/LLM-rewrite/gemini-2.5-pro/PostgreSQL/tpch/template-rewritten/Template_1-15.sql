
SELECT ^^^_A * sum(CASE
                       WHEN p.p_type LIKE &&&_A THEN l.l_extendedprice * (###_A - l.l_discount)
                       ELSE ###_B
                   END) / sum(l.l_extendedprice * (###_C - l.l_discount)) AS promo_revenue
FROM
  (SELECT l_partkey,
          l_extendedprice,
          l_discount
   FROM lineitem
   WHERE l_shipdate >= date &&&_B
     AND l_shipdate < (date &&&_C + interval &&&_D MONTH)) l
JOIN part p ON l.l_partkey = p.p_partkey;