WITH sales_with_items AS
  (SELECT ss_ticket_number,
          ss_item_sk,
          ss_list_price,
          ss_customer_sk,
          ss_sold_date_sk,
          i_category,
          i_manager_id
   FROM store_sales
   JOIN item ON ss_item_sk = i_item_sk),
     s1 AS
  (SELECT ss_ticket_number,
          ss_item_sk
   FROM sales_with_items
   WHERE ss_list_price BETWEEN 236 AND 250
     AND i_category IN ('Jewelry',
                           'Music')
     AND EXISTS
       (SELECT 1
        FROM date_dim
        WHERE d_date_sk = ss_sold_date_sk
          AND d_year BETWEEN 1998 AND 1998 + 1)
     AND EXISTS
       (SELECT 1
        FROM customer c
        JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
        JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
        WHERE c.c_customer_sk = ss_customer_sk
          AND cd.cd_marital_status = 'W'
          AND cd.cd_education_status = 'Primary')),
     s2 AS
  (SELECT ss_ticket_number,
          ss_item_sk
   FROM sales_with_items
   WHERE ss_list_price BETWEEN 236 AND 250
     AND i_manager_id BETWEEN 77 AND 96)
SELECT min(s1.ss_item_sk),
       min(s2.ss_item_sk),
       min(s1.ss_ticket_number),
       min(s1.ss_item_sk)
FROM s1
JOIN s2 ON s1.ss_ticket_number = s2.ss_ticket_number
WHERE s1.ss_item_sk < s2.ss_item_sk;