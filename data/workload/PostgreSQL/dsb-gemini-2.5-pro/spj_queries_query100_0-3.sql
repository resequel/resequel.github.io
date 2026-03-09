
SELECT min(i1.i_item_sk),
       min(i2.i_item_sk),
       min(s1.ss_ticket_number),
       min(s1.ss_item_sk)
FROM item i1
JOIN store_sales s1 ON i1.i_item_sk = s1.ss_item_sk
JOIN item i2
JOIN store_sales s2 ON i2.i_item_sk = s2.ss_item_sk ON s1.ss_ticket_number = s2.ss_ticket_number
JOIN date_dim d ON s1.ss_sold_date_sk = d.d_date_sk
JOIN customer c ON s1.ss_customer_sk = c.c_customer_sk
JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
WHERE i1.i_item_sk < i2.i_item_sk
  AND i1.i_category IN ('Jewelry',
                           'Music')
  AND i2.i_manager_id BETWEEN 77 AND 96
  AND s1.ss_list_price BETWEEN 236 AND 250
  AND s2.ss_list_price BETWEEN 236 AND 250
  AND d.d_year BETWEEN 1998 AND 1998 + 1
  AND cd.cd_marital_status = 'W'
  AND cd.cd_education_status = 'Primary';