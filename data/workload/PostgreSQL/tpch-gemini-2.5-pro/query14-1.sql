
SELECT 100.00 * sum(CASE
                       WHEN p.p_type LIKE 'PROMO%' THEN l.rev_a
                       ELSE 0
                   END) / NULLIF(sum(l.rev_c), 0) AS promo_revenue
FROM
  (SELECT l_partkey,
          l_extendedprice * (1 - l_discount) AS rev_a,
          l_extendedprice * (1 - l_discount) AS rev_c
   FROM lineitem
   WHERE l_shipdate >= date '1995-09-01'
     AND l_shipdate < date '1995-09-01' + interval '1' MONTH) l
JOIN part p ON l.l_partkey = p.p_partkey;