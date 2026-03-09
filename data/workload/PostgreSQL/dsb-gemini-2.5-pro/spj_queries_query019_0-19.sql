WITH filtered_ss AS
  (SELECT ss.ss_item_sk,
          ss.ss_customer_sk,
          ss.ss_store_sk,
          ss.ss_ext_sales_price
   FROM store_sales ss
   WHERE ss.ss_wholesale_cost BETWEEN 80 AND 100
     AND EXISTS
       (SELECT 1
        FROM date_dim d
        WHERE d.d_date_sk = ss.ss_sold_date_sk
          AND d.d_year = 2002
          AND d.d_moy = 8)
     AND EXISTS
       (SELECT 1
        FROM item i
        WHERE i.i_item_sk = ss.ss_item_sk
          AND i.i_category = 'Home')
     AND EXISTS
       (SELECT 1
        FROM customer c
        JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
        WHERE c.c_customer_sk = ss.ss_customer_sk
          AND c.c_birth_month = 4
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