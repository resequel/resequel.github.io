WITH valid_pairs AS
  (SELECT c.c_customer_sk,
          s.s_store_sk
   FROM customer c,
        customer_address ca,
        store s
   WHERE c.c_current_addr_sk = ca.ca_address_sk
     AND c.c_birth_month = 4
     AND ca.ca_state = 'GA'
     AND substring(ca.ca_zip, 1, 5) <> substring(s.s_zip, 1, 5))
SELECT min(i.i_brand_id),
       min(i.i_manufact_id),
       min(ss.ss_ext_sales_price)
FROM store_sales ss
JOIN valid_pairs vp ON ss.ss_customer_sk = vp.c_customer_sk
AND ss.ss_store_sk = vp.s_store_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
WHERE d.d_year = 2002
  AND d.d_moy = 8
  AND i.i_category = 'Home'
  AND ss.ss_wholesale_cost BETWEEN 80 AND 100;