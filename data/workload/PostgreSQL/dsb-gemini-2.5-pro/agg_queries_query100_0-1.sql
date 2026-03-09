
SELECT s1.ss_item_sk,
       s2.ss_item_sk,
       COUNT(*) AS cnt
FROM
  (SELECT ss_ticket_number,
          ss_item_sk
   FROM store_sales
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   JOIN customer ON ss_customer_sk = c_customer_sk
   JOIN customer_demographics ON c_current_cdemo_sk = cd_demo_sk
   JOIN customer_address ON c_current_addr_sk = ca_address_sk
   JOIN item ON ss_item_sk = i_item_sk
   WHERE d_year BETWEEN 1998 AND 1998 + 1
     AND cd_marital_status = 'W'
     AND cd_education_status = 'Primary'
     AND i_category IN ('Jewelry',
                           'Music')
     AND ss_list_price BETWEEN 236 AND 250) AS s1
JOIN
  (SELECT ss_ticket_number,
          ss_item_sk
   FROM store_sales
   JOIN item ON ss_item_sk = i_item_sk
   WHERE i_manager_id BETWEEN 77 AND 96
     AND ss_list_price BETWEEN 236 AND 250) AS s2 ON s1.ss_ticket_number = s2.ss_ticket_number
AND s1.ss_item_sk < s2.ss_item_sk
GROUP BY s1.ss_item_sk,
         s2.ss_item_sk
ORDER BY cnt;