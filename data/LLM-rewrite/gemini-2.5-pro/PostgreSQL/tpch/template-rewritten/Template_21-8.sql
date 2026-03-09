
SELECT sum(l_extendedprice * (###_A - l_discount)) AS revenue
FROM lineitem
JOIN part ON p_partkey = l_partkey
WHERE (p_brand = &&&_A
       AND p_container IN N_SSS_A
       AND l_quantity BETWEEN ###_B AND ###_C + ###_D
       AND p_size BETWEEN ###_E AND ###_F
       AND l_shipmode IN N_SSS_B
       AND l_shipinstruct = &&&_B)
  OR (p_brand = &&&_C
      AND p_container IN N_SSS_C
      AND l_quantity BETWEEN ###_G AND ###_H + ###_I
      AND p_size BETWEEN ###_J AND ###_K
      AND l_shipmode IN N_SSS_D
      AND l_shipinstruct = &&&_D)
  OR (p_brand = &&&_E
      AND p_container IN N_SSS_E
      AND l_quantity BETWEEN ###_L AND ###_M + ###_N
      AND p_size BETWEEN ###_O AND ###_P
      AND l_shipmode IN N_SSS_F
      AND l_shipinstruct = &&&_F);