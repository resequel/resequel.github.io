WITH l AS
  (SELECT l_partkey,
          l_extendedprice * (1 - l_discount) AS rev_a,
          l_extendedprice * (1 - l_discount) AS rev_c
   FROM lineitem
   WHERE l_shipdate >= date '1995-09-01'
     AND l_shipdate < date '1995-09-01' + interval '1' MONTH)
SELECT 100.00 * sum(CASE
                       WHEN p.p_type LIKE 'PROMO%' THEN l.rev_a
                       ELSE 0
                   END) / sum(l.rev_c) AS promo_revenue
FROM l
JOIN part p ON l.l_partkey = p.p_partkey;