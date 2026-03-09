
SELECT fi.i_brand_id,
       fi.i_brand,
       fi.i_manufact_id,
       fi.i_manufact,
       sum(ss.ss_ext_sales_price) AS ext_price
FROM store_sales ss
JOIN
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 2002
     AND d_moy = 8) fd ON ss.ss_sold_date_sk = fd.d_date_sk
JOIN
  (SELECT i_item_sk,
          i_brand_id,
          i_brand,
          i_manufact_id,
          i_manufact
   FROM item
   WHERE i_category = 'Home') fi ON ss.ss_item_sk = fi.i_item_sk
JOIN
  (SELECT c.c_customer_sk,
          ca.ca_zip
   FROM customer c
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   WHERE c.c_birth_month = 4
     AND ca.ca_state = 'GA') ci ON ss.ss_customer_sk = ci.c_customer_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
WHERE ss.ss_wholesale_cost BETWEEN 80 AND 100
  AND substring(ci.ca_zip, 1, 5) <> substring(s.s_zip, 1, 5)
GROUP BY fi.i_brand,
         fi.i_brand_id,
         fi.i_manufact_id,
         fi.i_manufact
ORDER BY ext_price DESC,
         fi.i_brand,
         fi.i_brand_id,
         fi.i_manufact_id,
         fi.i_manufact
LIMIT 100;