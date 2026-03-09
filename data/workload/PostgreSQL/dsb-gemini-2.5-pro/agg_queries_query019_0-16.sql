WITH filtered_sales AS
  (SELECT ss_item_sk,
          ss_customer_sk,
          ss_store_sk,
          ss_ext_sales_price
   FROM store_sales ss
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   WHERE d.d_year = 2002
     AND d.d_moy = 8
     AND ss.ss_wholesale_cost BETWEEN 80 AND 100),
     customer_zips AS
  (SELECT c.c_customer_sk,
          SUBSTRING(ca.ca_zip, 1, 5) AS cust_zip_part
   FROM customer c
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   WHERE c.c_birth_month = 4
     AND ca.ca_state = 'GA')
SELECT i.i_brand_id,
       i.i_brand,
       i.i_manufact_id,
       i.i_manufact,
       sum(fs.ss_ext_sales_price) AS ext_price
FROM filtered_sales fs
JOIN item i ON fs.ss_item_sk = i.i_item_sk
JOIN store s ON fs.ss_store_sk = s.s_store_sk
JOIN customer_zips cz ON fs.ss_customer_sk = cz.c_customer_sk
WHERE i.i_category = 'Home'
  AND cz.cust_zip_part <> SUBSTRING(s.s_zip, 1, 5)
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