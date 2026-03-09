WITH filtered_dates AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year BETWEEN 1998 AND 1998 + 1),
     filtered_customers AS
  (SELECT c.c_customer_sk
   FROM customer c
   JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   WHERE cd.cd_marital_status = 'W'
     AND cd.cd_education_status = 'Primary'),
     item1_filtered AS
  (SELECT i_item_sk
   FROM item
   WHERE i_category IN ('Jewelry',
                           'Music')),
     item2_filtered AS
  (SELECT i_item_sk
   FROM item
   WHERE i_manager_id BETWEEN 77 AND 96)
SELECT min(s1.ss_item_sk),
       min(s2.ss_item_sk),
       min(s1.ss_ticket_number),
       min(s1.ss_item_sk)
FROM store_sales s1
JOIN store_sales s2 ON s1.ss_ticket_number = s2.ss_ticket_number
JOIN filtered_dates ON s1.ss_sold_date_sk = filtered_dates.d_date_sk
JOIN filtered_customers ON s1.ss_customer_sk = filtered_customers.c_customer_sk
JOIN item1_filtered i1 ON s1.ss_item_sk = i1.i_item_sk
JOIN item2_filtered i2 ON s2.ss_item_sk = i2.i_item_sk
WHERE s1.ss_list_price BETWEEN 236 AND 250
  AND s2.ss_list_price BETWEEN 236 AND 250
  AND s1.ss_item_sk < s2.ss_item_sk;