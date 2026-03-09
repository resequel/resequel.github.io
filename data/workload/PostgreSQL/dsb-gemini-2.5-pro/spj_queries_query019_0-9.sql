WITH filtered_ss AS
  (SELECT ss.ss_item_sk,
          ss.ss_customer_sk,
          ss.ss_store_sk,
          ss.ss_ext_sales_price
   FROM store_sales ss
   WHERE ss.ss_wholesale_cost BETWEEN 80 AND 100
     AND ss.ss_sold_date_sk IN
       (SELECT d_date_sk
        FROM date_dim
        WHERE d_year = 2002
          AND d_moy = 8)
     AND ss.ss_item_sk IN
       (SELECT i_item_sk
        FROM item
        WHERE i_category = 'Home')
     AND ss.ss_customer_sk IN
       (SELECT c.c_customer_sk
        FROM customer c
        JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
        WHERE c.c_birth_month = 4
          AND ca.ca_state = 'GA'))
SELECT min(i.i_brand_id),
       min(i.i_manufact_id),
       min(fss.ss_ext_sales_price)
FROM filtered_ss fss
JOIN item i ON fss.ss_item_sk = i.i_item_sk
JOIN customer c ON fss.ss_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN store s ON fss.ss_store_sk = s.s_store_sk
WHERE substring(ca.ca_zip, 1, 5) <> substring(s.s_zip, 1, 5);