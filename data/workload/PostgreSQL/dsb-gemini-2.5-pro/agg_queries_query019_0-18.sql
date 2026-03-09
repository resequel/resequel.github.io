WITH filtered_sales_items AS
  (SELECT ss.ss_customer_sk,
          ss.ss_store_sk,
          ss.ss_ext_sales_price,
          i.i_brand_id,
          i.i_brand,
          i.i_manufact_id,
          i.i_manufact
   FROM store_sales ss
   JOIN item i ON ss.ss_item_sk = i.i_item_sk
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   WHERE i.i_category = 'Home'
     AND d.d_year = 2002
     AND d.d_moy = 8
     AND ss.ss_wholesale_cost BETWEEN 80 AND 100),
     filtered_customers AS
  (SELECT c.c_customer_sk,
          ca.ca_zip
   FROM customer c
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   WHERE c.c_birth_month = 4
     AND ca.ca_state = 'GA')
SELECT fsi.i_brand_id,
       fsi.i_brand,
       fsi.i_manufact_id,
       fsi.i_manufact,
       sum(fsi.ss_ext_sales_price) AS ext_price
FROM filtered_sales_items fsi
JOIN filtered_customers fc ON fsi.ss_customer_sk = fc.c_customer_sk
JOIN store s ON fsi.ss_store_sk = s.s_store_sk
WHERE SUBSTRING(fc.ca_zip, 1, 5) <> SUBSTRING(s.s_zip, 1, 5)
GROUP BY fsi.i_brand,
         fsi.i_brand_id,
         fsi.i_manufact_id,
         fsi.i_manufact
ORDER BY ext_price DESC,
         fsi.i_brand,
         fsi.i_brand_id,
         fsi.i_manufact_id,
         fsi.i_manufact
LIMIT 100;