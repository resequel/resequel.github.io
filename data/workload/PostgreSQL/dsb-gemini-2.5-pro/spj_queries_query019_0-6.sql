WITH filtered_date AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 2002
     AND d_moy = 8),
     filtered_item AS
  (SELECT i_item_sk,
          i_brand_id,
          i_manufact_id
   FROM item
   WHERE i_category = 'Home'),
     filtered_customer AS
  (SELECT c_customer_sk,
          c_current_addr_sk
   FROM customer
   WHERE c_birth_month = 4),
     filtered_address AS
  (SELECT ca_address_sk,
          ca_zip
   FROM customer_address
   WHERE ca_state = 'GA')
SELECT min(fi.i_brand_id),
       min(fi.i_manufact_id),
       min(ss.ss_ext_sales_price)
FROM store_sales ss
JOIN filtered_date fd ON ss.ss_sold_date_sk = fd.d_date_sk
JOIN filtered_item fi ON ss.ss_item_sk = fi.i_item_sk
JOIN filtered_customer fc ON ss.ss_customer_sk = fc.c_customer_sk
JOIN filtered_address fa ON fc.c_current_addr_sk = fa.ca_address_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
WHERE ss.ss_wholesale_cost BETWEEN 80 AND 100
  AND substring(fa.ca_zip, 1, 5) <> substring(s.s_zip, 1, 5);