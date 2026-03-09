WITH filtered_dates AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year BETWEEN 1998 AND 1998 + 1),
     filtered_item1 AS
  (SELECT i_item_sk
   FROM item
   WHERE i_category IN ('Jewelry',
                           'Music')),
     filtered_item2 AS
  (SELECT i_item_sk
   FROM item
   WHERE i_manager_id BETWEEN 77 AND 96),
     filtered_customers AS
  (SELECT c.c_customer_sk
   FROM customer c
   JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   WHERE cd.cd_marital_status = 'W'
     AND cd.cd_education_status = 'Primary'),
     sales1 AS
  (SELECT ss.ss_ticket_number,
          ss.ss_item_sk
   FROM store_sales ss
   JOIN filtered_dates d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN filtered_item1 i1 ON ss.ss_item_sk = i1.i_item_sk
   JOIN filtered_customers c ON ss.ss_customer_sk = c.c_customer_sk
   WHERE ss.ss_list_price BETWEEN 236 AND 250),
     sales2 AS
  (SELECT ss.ss_ticket_number,
          ss.ss_item_sk
   FROM store_sales ss
   JOIN filtered_item2 i2 ON ss.ss_item_sk = i2.i_item_sk
   WHERE ss.ss_list_price BETWEEN 236 AND 250)
SELECT min(s1.ss_item_sk),
       min(s2.ss_item_sk),
       min(s1.ss_ticket_number),
       min(s1.ss_item_sk)
FROM sales1 s1
JOIN sales2 s2 ON s1.ss_ticket_number = s2.ss_ticket_number
WHERE s1.ss_item_sk < s2.ss_item_sk;