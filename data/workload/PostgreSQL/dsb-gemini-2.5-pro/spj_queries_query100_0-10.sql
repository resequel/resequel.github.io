WITH filtered_customers AS
  (SELECT c.c_customer_sk
   FROM customer c
   JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
   WHERE cd.cd_marital_status = 'W'
     AND cd.cd_education_status = 'Primary'
     AND c.c_current_addr_sk IS NOT NULL),
     s1 AS
  (SELECT ss_ticket_number,
          ss_item_sk
   FROM store_sales s
   JOIN item i ON s.ss_item_sk = i.i_item_sk
   JOIN date_dim d ON s.ss_sold_date_sk = d.d_date_sk
   WHERE s.ss_list_price BETWEEN 236 AND 250
     AND i.i_category IN ('Jewelry',
                           'Music')
     AND d.d_year BETWEEN 1998 AND 1998 + 1
     AND s.ss_customer_sk IN
       (SELECT c_customer_sk
        FROM filtered_customers)),
     s2 AS
  (SELECT ss_ticket_number,
          ss_item_sk
   FROM store_sales s
   JOIN item i ON s.ss_item_sk = i.i_item_sk
   WHERE s.ss_list_price BETWEEN 236 AND 250
     AND i.i_manager_id BETWEEN 77 AND 96)
SELECT min(s1.ss_item_sk),
       min(s2.ss_item_sk),
       min(s1.ss_ticket_number),
       min(s1.ss_item_sk)
FROM s1
JOIN s2 ON s1.ss_ticket_number = s2.ss_ticket_number
WHERE s1.ss_item_sk < s2.ss_item_sk;