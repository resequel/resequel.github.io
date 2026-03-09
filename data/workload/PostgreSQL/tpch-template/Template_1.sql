SELECT ^^^_A * sum(CASE
                        WHEN p_type like &&&_A THEN l_extendedprice * (###_A - l_discount)
                        ELSE ###_B
                    END) / sum(l_extendedprice * (###_C - l_discount)) AS promo_revenue
FROM lineitem,
     part
WHERE l_partkey = p_partkey
  AND l_shipdate >= date &&&_B
  AND l_shipdate < date &&&_C + interval &&&_D MONTH;