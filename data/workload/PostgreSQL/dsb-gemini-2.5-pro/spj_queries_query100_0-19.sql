WITH s1_base AS
  (SELECT ss_ticket_number,
          ss_item_sk
   FROM store_sales
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   JOIN customer ON ss_customer_sk = c_customer_sk
   JOIN customer_demographics ON c_current_cdemo_sk = cd_demo_sk
   JOIN customer_address ON c_current_addr_sk = ca_address_sk
   WHERE d_year BETWEEN 1998 AND 1998 + 1
     AND cd_marital_status = 'W'
     AND cd_education_status = 'Primary'
     AND ss_list_price BETWEEN 236 AND 250),
     s2_base AS
  (SELECT ss_ticket_number,
          ss_item_sk
   FROM store_sales
   WHERE ss_list_price BETWEEN 236 AND 250)
SELECT min(i1.i_item_sk),
       min(i2.i_item_sk),
       min(s1.ss_ticket_number),
       min(s1.ss_item_sk)
FROM s1_base s1
JOIN item i1 ON s1.ss_item_sk = i1.i_item_sk
JOIN s2_base s2 ON s1.ss_ticket_number = s2.ss_ticket_number
JOIN item i2 ON s2.ss_item_sk = i2.i_item_sk
WHERE i1.i_category IN ('Jewelry',
                           'Music')
  AND i2.i_manager_id BETWEEN 77 AND 96
  AND i1.i_item_sk < i2.i_item_sk;