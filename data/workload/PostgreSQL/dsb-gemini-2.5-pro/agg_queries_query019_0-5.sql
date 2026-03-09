WITH relevant_sales AS
  (SELECT ss.ss_item_sk,
          ss.ss_customer_sk,
          ss.ss_store_sk,
          ss.ss_ext_sales_price
   FROM store_sales ss
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   WHERE d.d_year = 2002
     AND d.d_moy = 8
     AND ss.ss_wholesale_cost BETWEEN 80 AND 100)
SELECT i.i_brand_id,
       i.i_brand,
       i.i_manufact_id,
       i.i_manufact,
       sum(rs.ss_ext_sales_price) AS ext_price
FROM relevant_sales rs
JOIN item i ON rs.ss_item_sk = i.i_item_sk
JOIN customer c ON rs.ss_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN store s ON rs.ss_store_sk = s.s_store_sk
WHERE i.i_category = 'Home'
  AND c.c_birth_month = 4
  AND ca.ca_state = 'GA'
  AND substring(ca.ca_zip, 1, 5) <> substring(s.s_zip, 1, 5)
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