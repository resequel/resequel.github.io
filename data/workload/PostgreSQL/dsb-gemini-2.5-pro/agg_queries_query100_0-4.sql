WITH sales1 AS
  (SELECT ss_ticket_number,
          ss_item_sk
   FROM store_sales
   JOIN item ON ss_item_sk = i_item_sk
   WHERE ss_list_price BETWEEN 236 AND 250
     AND i_category IN ('Jewelry',
                           'Music')),
     sales2 AS
  (SELECT ss_ticket_number,
          ss_item_sk
   FROM store_sales
   JOIN item ON ss_item_sk = i_item_sk
   WHERE ss_list_price BETWEEN 236 AND 250
     AND i_manager_id BETWEEN 77 AND 96)
SELECT s1.ss_item_sk,
       s2.ss_item_sk,
       COUNT(*) AS cnt
FROM sales1 s1
JOIN sales2 s2 ON s1.ss_ticket_number = s2.ss_ticket_number
WHERE s1.ss_item_sk < s2.ss_item_sk
  AND EXISTS
    (SELECT 1
     FROM date_dim
     WHERE d_date_sk = s1.ss_sold_date_sk
       AND d_year BETWEEN 1998 AND 1998 + 1)
  AND EXISTS
    (SELECT 1
     FROM customer
     JOIN customer_demographics ON c_current_cdemo_sk = cd_demo_sk
     JOIN customer_address ON c_current_addr_sk = ca_address_sk
     WHERE c_customer_sk = s1.ss_customer_sk
       AND cd_marital_status = 'W'
       AND cd_education_status = 'Primary')
GROUP BY s1.ss_item_sk,
         s2.ss_item_sk
ORDER BY cnt;