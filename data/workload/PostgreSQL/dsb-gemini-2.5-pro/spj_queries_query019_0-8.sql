WITH sales_details AS
  (SELECT ss.ss_store_sk,
          ss.ss_ext_sales_price,
          i.i_brand_id,
          i.i_manufact_id,
          ca.ca_zip
   FROM store_sales ss
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN item i ON ss.ss_item_sk = i.i_item_sk
   JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   WHERE ss.ss_wholesale_cost BETWEEN 80 AND 100
     AND d.d_year = 2002
     AND d.d_moy = 8
     AND i.i_category = 'Home'
     AND c.c_birth_month = 4
     AND ca.ca_state = 'GA')
SELECT min(sd.i_brand_id),
       min(sd.i_manufact_id),
       min(sd.ss_ext_sales_price)
FROM sales_details sd
JOIN store s ON sd.ss_store_sk = s.s_store_sk
WHERE substring(sd.ca_zip, 1, 5) <> substring(s.s_zip, 1, 5);