
SELECT i.i_brand_id,
       i.i_brand,
       i.i_manufact_id,
       i.i_manufact,
       sum(ss.ss_ext_sales_price) AS ext_price
FROM store_sales ss
INNER JOIN date_dim d ON d.d_date_sk = ss.ss_sold_date_sk
INNER JOIN item i ON ss.ss_item_sk = i.i_item_sk
INNER JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
INNER JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
INNER JOIN store s ON ss.ss_store_sk = s.s_store_sk
WHERE i.i_category = 'Home'
  AND d.d_year = 2002
  AND d.d_moy = 8
  AND SUBSTRING(ca.ca_zip, 1, 5) <> SUBSTRING(s.s_zip, 1, 5)
  AND ca.ca_state = 'GA'
  AND c.c_birth_month = 4
  AND ss.ss_wholesale_cost BETWEEN 80 AND 100
GROUP BY i.i_brand,
         i.i_brand_id,
         i.i_manufact_id,
         i.i_manufact
ORDER BY ext_price DESC,
         i.i_brand,
         i.i_brand_id,
         i.i_manufact_id,
         i.i_manufact
LIMIT 100;