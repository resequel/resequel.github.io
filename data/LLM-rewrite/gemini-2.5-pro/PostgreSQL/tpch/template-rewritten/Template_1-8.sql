
SELECT ^^^_A * sum(CASE
                       WHEN p.p_type LIKE &&&_A THEN l.rev_a
                       ELSE ###_B
                   END) / sum(l.rev_c) AS promo_revenue
FROM
  (SELECT l_partkey,
          l_extendedprice * (###_A - l_discount) AS rev_a,
          l_extendedprice * (###_C - l_discount) AS rev_c
   FROM lineitem
   WHERE l_shipdate >= date &&&_B
     AND l_shipdate < date &&&_C + interval &&&_D MONTH) l
JOIN
  (SELECT p_partkey,
          p_type
   FROM part) p ON l.l_partkey = p.p_partkey;