
SELECT sum(l.l_extendedprice * (###_A - l.l_discount)) AS revenue
FROM
  (SELECT l_partkey,
          l_extendedprice,
          l_discount,
          l_quantity,
          l_shipmode,
          l_shipinstruct
   FROM lineitem) l
INNER JOIN
  (SELECT p_partkey,
          p_brand,
          p_container,
          p_size
   FROM part) p ON p.p_partkey = l.l_partkey
WHERE (p.p_brand = &&&_A
       AND p.p_container IN N_SSS_A
       AND l.l_quantity >= ###_B
       AND l.l_quantity <= ###_C + ###_D
       AND p.p_size BETWEEN ###_E AND ###_F
       AND l.l_shipmode IN N_SSS_B
       AND l.l_shipinstruct = &&&_B)
  OR (p.p_brand = &&&_C
      AND p.p_container IN N_SSS_C
      AND l.l_quantity >= ###_G
      AND l.l_quantity <= ###_H + ###_I
      AND p.p_size BETWEEN ###_J AND ###_K
      AND l.l_shipmode IN N_SSS_D
      AND l.l_shipinstruct = &&&_D)
  OR (p.p_brand = &&&_E
      AND p.p_container IN N_SSS_E
      AND l.l_quantity >= ###_L
      AND l.l_quantity <= ###_M + ###_N
      AND p.p_size BETWEEN ###_O AND ###_P
      AND l.l_shipmode IN N_SSS_F
      AND l.l_shipinstruct = &&&_F);