
SELECT sum(l.l_extendedprice * (1 - l.l_discount)) AS revenue
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
WHERE (p.p_brand = 'Brand#12'
       AND p.p_container IN ('SM CASE',
                           'SM BOX',
                           'SM PACK',
                           'SM PKG')
       AND l.l_quantity >= 1
       AND l.l_quantity <= 1 + 10
       AND p.p_size BETWEEN 1 AND 5
       AND l.l_shipmode IN ('AIR',
                          'AIR REG')
       AND l.l_shipinstruct = 'DELIVER IN PERSON')
  OR (p.p_brand = 'Brand#23'
      AND p.p_container IN ('MED BAG',
                          'MED BOX',
                          'MED PKG',
                          'MED PACK')
      AND l.l_quantity >= 10
      AND l.l_quantity <= 10 + 10
      AND p.p_size BETWEEN 1 AND 10
      AND l.l_shipmode IN ('AIR',
                         'AIR REG')
      AND l.l_shipinstruct = 'DELIVER IN PERSON')
  OR (p.p_brand = 'Brand#34'
      AND p.p_container IN ('LG CASE',
                          'LG BOX',
                          'LG PACK',
                          'LG PKG')
      AND l.l_quantity >= 20
      AND l.l_quantity <= 20 + 10
      AND p.p_size BETWEEN 1 AND 15
      AND l.l_shipmode IN ('AIR',
                         'AIR REG')
      AND l.l_shipinstruct = 'DELIVER IN PERSON');