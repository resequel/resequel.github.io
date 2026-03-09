WITH s1_candidates AS
  (SELECT ss_ticket_number,
          ss_item_sk
   FROM store_sales s
   JOIN date_dim d ON s.ss_sold_date_sk = d.d_date_sk
   JOIN customer c ON s.ss_customer_sk = c.c_customer_sk
   JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   WHERE d.d_year BETWEEN 1998 AND 1998 + 1
     AND cd.cd_marital_status = 'W'
     AND cd.cd_education_status = 'Primary'
     AND s.ss_list_price BETWEEN 236 AND 250),
     s2_candidates AS
  (SELECT ss_ticket_number,
          ss_item_sk
   FROM store_sales
   WHERE ss_list_price BETWEEN 236 AND 250)
SELECT min(i1.i_item_sk),
       min(i2.i_item_sk),
       min(s1.ss_ticket_number),
       min(s1.ss_item_sk)
FROM s1_candidates s1
JOIN s2_candidates s2 ON s1.ss_ticket_number = s2.ss_ticket_number
JOIN item i1 ON s1.ss_item_sk = i1.i_item_sk
JOIN item i2 ON s2.ss_item_sk = i2.i_item_sk
WHERE i1.i_category IN ('Jewelry',
                           'Music')
  AND i2.i_manager_id BETWEEN 77 AND 96
  AND i1.i_item_sk < i2.i_item_sk;