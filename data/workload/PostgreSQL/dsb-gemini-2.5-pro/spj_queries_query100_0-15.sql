
SELECT min(s1.ss_item_sk),
       min(s2.ss_item_sk),
       min(s1.ss_ticket_number),
       min(s1.ss_item_sk)
FROM store_sales s1
JOIN store_sales s2 ON s1.ss_ticket_number = s2.ss_ticket_number
JOIN item i1 ON s1.ss_item_sk = i1.i_item_sk
JOIN item i2 ON s2.ss_item_sk = i2.i_item_sk
WHERE s1.ss_item_sk < s2.ss_item_sk
  AND s1.ss_list_price BETWEEN 236 AND 250
  AND s2.ss_list_price BETWEEN 236 AND 250
  AND i1.i_category IN ('Jewelry',
                           'Music')
  AND i2.i_manager_id BETWEEN 77 AND 96
  AND EXISTS
    (SELECT 1
     FROM date_dim d
     WHERE d.d_date_sk = s1.ss_sold_date_sk
       AND d.d_year BETWEEN 1998 AND 1998 + 1)
  AND EXISTS
    (SELECT 1
     FROM customer c
     JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
     JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
     WHERE c.c_customer_sk = s1.ss_customer_sk
       AND cd.cd_marital_status = 'W'
       AND cd.cd_education_status = 'Primary');