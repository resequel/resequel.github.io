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
     filtered_item1 AS
  (SELECT i_item_sk
   FROM item
   WHERE i_category IN ('Jewelry',
                           'Music')),
     filtered_item2 AS
  (SELECT i_item_sk
   FROM item
   WHERE i_manager_id BETWEEN 77 AND 96),
     s1 AS
  (SELECT ss_ticket_number,
          ss_item_sk
   FROM store_sales
   WHERE ss_list_price BETWEEN 236 AND 250
     AND ss_sold_date_sk IN
       (SELECT d_date_sk
        FROM filtered_dates)
     AND ss_customer_sk IN
       (SELECT c_customer_sk
        FROM filtered_customers)
     AND ss_item_sk IN
       (SELECT i_item_sk
        FROM filtered_item1)),
     s2 AS
  (SELECT ss_ticket_number,
          ss_item_sk
   FROM store_sales
   WHERE ss_list_price BETWEEN 236 AND 250
     AND ss_item_sk IN
       (SELECT i_item_sk
        FROM filtered_item2))
SELECT min(s1.ss_item_sk),
       min(s2.ss_item_sk),
       min(s1.ss_ticket_number),
       min(s1.ss_item_sk)
FROM s1
JOIN s2 ON s1.ss_ticket_number = s2.ss_ticket_number
WHERE s1.ss_item_sk < s2.ss_item_sk;