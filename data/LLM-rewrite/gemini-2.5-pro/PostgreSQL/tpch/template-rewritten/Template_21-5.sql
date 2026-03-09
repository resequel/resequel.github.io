
SELECT sum(l_extendedprice * (###_A - l_discount)) AS revenue
FROM part
INNER JOIN lineitem ON p_partkey = l_partkey
WHERE (p_brand = &&&_A
       AND p_container IN N_SSS_A
       AND l_quantity >= ###_B
       AND l_quantity <= ###_C + ###_D
       AND p_size BETWEEN ###_E AND ###_F
       AND l_shipmode IN N_SSS_B
       AND l_shipinstruct = &&&_B)
  OR (p_brand = &&&_C
      AND p_container IN N_SSS_C
      AND l_quantity >= ###_G
      AND l_quantity <= ###_H + ###_I
      AND p_size BETWEEN ###_J AND ###_K
      AND l_shipmode IN N_SSS_D
      AND l_shipinstruct = &&&_D)
  OR (p_brand = &&&_E
      AND p_container IN N_SSS_E
      AND l_quantity >= ###_L
      AND l_quantity <= ###_M + ###_N
      AND p_size BETWEEN ###_O AND ###_P
      AND l_shipmode IN N_SSS_F
      AND l_shipinstruct = &&&_F);