
SELECT i_brand_id brand_id,
       i_brand brand,
       i_manufact_id,
       i_manufact,
       sum(ss_ext_sales_price) ext_price
FROM store_sales
JOIN date_dim ON d_date_sk = ss_sold_date_sk
JOIN item ON ss_item_sk = i_item_sk
JOIN customer ON ss_customer_sk = c_customer_sk
JOIN customer_address ON c_current_addr_sk = ca_address_sk
JOIN store ON ss_store_sk = s_store_sk
WHERE i_category = 'Home'
  AND d_year = 2002
  AND d_moy = 8
  AND ca_state = 'GA'
  AND c_birth_month = 4
  AND ss_wholesale_cost BETWEEN 80 AND 100
  AND substring(ca_zip, 1, 5) <> substring(s_zip, 1, 5)
GROUP BY i_brand,
         i_brand_id,
         i_manufact_id,
         i_manufact
ORDER BY ext_price DESC,
         i_brand,
         i_brand_id,
         i_manufact_id,
         i_manufact
LIMIT 100;