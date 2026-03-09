
SELECT min(s1.ss_item_sk),
       min(s2.ss_item_sk),
       min(s1.ss_ticket_number),
       min(s1.ss_item_sk)
FROM
  (SELECT ss.ss_ticket_number,
          ss.ss_item_sk
   FROM store_sales ss
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN item i1 ON ss.ss_item_sk = i1.i_item_sk
   JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
   JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   WHERE d.d_year BETWEEN 1998 AND 1998 + 1
     AND i1.i_category IN ('Jewelry',
                           'Music')
     AND cd.cd_marital_status = 'W'
     AND cd.cd_education_status = 'Primary'
     AND ss.ss_list_price BETWEEN 236 AND 250) AS s1
JOIN
  (SELECT ss.ss_ticket_number,
          ss.ss_item_sk
   FROM store_sales ss
   JOIN item i2 ON ss.ss_item_sk = i2.i_item_sk
   WHERE i2.i_manager_id BETWEEN 77 AND 96
     AND ss.ss_list_price BETWEEN 236 AND 250) AS s2 ON s1.ss_ticket_number = s2.ss_ticket_number
WHERE s1.ss_item_sk < s2.ss_item_sk;