WITH filtered_item1 AS
  (SELECT i_item_sk
   FROM item
   WHERE i_category IN ('Jewelry',
                           'Music')),
     filtered_item2 AS
  (SELECT i_item_sk
   FROM item
   WHERE i_manager_id BETWEEN 77 AND 96),
     filtered_customers AS
  (SELECT c_customer_sk
   FROM customer
   INNER JOIN customer_demographics ON c_current_cdemo_sk = cd_demo_sk
   INNER JOIN customer_address ON c_current_addr_sk = ca_address_sk
   WHERE cd_marital_status = 'W'
     AND cd_education_status = 'Primary'),
     sales1 AS
  (SELECT ss_ticket_number,
          ss_item_sk
   FROM store_sales
   INNER JOIN date_dim ON ss_sold_date_sk = d_date_sk
   INNER JOIN filtered_customers ON ss_customer_sk = c_customer_sk
   INNER JOIN filtered_item1 ON ss_item_sk = filtered_item1.i_item_sk
   WHERE d_year BETWEEN 1998 AND 1998 + 1
     AND ss_list_price BETWEEN 236 AND 250),
     sales2 AS
  (SELECT ss_ticket_number,
          ss_item_sk
   FROM store_sales
   INNER JOIN filtered_item2 ON ss_item_sk = filtered_item2.i_item_sk
   WHERE ss_list_price BETWEEN 236 AND 250)
SELECT s1.ss_item_sk,
       s2.ss_item_sk,
       COUNT(*) AS cnt
FROM sales1 s1
INNER JOIN sales2 s2 ON s1.ss_ticket_number = s2.ss_ticket_number
AND s1.ss_item_sk < s2.ss_item_sk
GROUP BY s1.ss_item_sk,
         s2.ss_item_sk
ORDER BY cnt;