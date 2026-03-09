WITH item1_filtered AS
  (SELECT i_item_sk
   FROM item
   WHERE i_category IN ('Jewelry',
                           'Music')),
     item2_filtered AS
  (SELECT i_item_sk
   FROM item
   WHERE i_manager_id BETWEEN 77 AND 96),
     sales_base AS
  (SELECT ss_ticket_number,
          ss_item_sk,
          ss_list_price
   FROM store_sales
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   JOIN customer ON ss_customer_sk = c_customer_sk
   JOIN customer_demographics ON c_current_cdemo_sk = cd_demo_sk
   WHERE d_year BETWEEN 1998 AND 1998 + 1
     AND cd_marital_status = 'W'
     AND cd_education_status = 'Primary')
SELECT s1.ss_item_sk,
       s2.ss_item_sk,
       count(*) AS cnt
FROM sales_base s1
JOIN item1_filtered i1 ON s1.ss_item_sk = i1.i_item_sk
JOIN sales_base s2 ON s1.ss_ticket_number = s2.ss_ticket_number
JOIN item2_filtered i2 ON s2.ss_item_sk = i2.i_item_sk
WHERE s1.ss_list_price BETWEEN 236 AND 250
  AND s2.ss_list_price BETWEEN 236 AND 250
  AND s1.ss_item_sk < s2.ss_item_sk
GROUP BY s1.ss_item_sk,
         s2.ss_item_sk
ORDER BY cnt;