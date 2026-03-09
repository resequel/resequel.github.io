WITH filtered_sales_items AS
  (SELECT ss_ticket_number,
          i.i_item_sk,
          i.i_category,
          i.i_manager_id,
          ss_list_price
   FROM store_sales
   JOIN item i ON ss_item_sk = i.i_item_sk
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   JOIN customer ON ss_customer_sk = c_customer_sk
   JOIN customer_demographics ON c_current_cdemo_sk = cd_demo_sk
   WHERE d_year BETWEEN 1998 AND 1998 + 1
     AND cd_marital_status = 'W'
     AND cd_education_status = 'Primary'),
     sales1 AS
  (SELECT ss_ticket_number,
          i_item_sk
   FROM filtered_sales_items
   WHERE ss_list_price BETWEEN 236 AND 250
     AND i_category IN ('Jewelry',
                           'Music')),
     sales2 AS
  (SELECT ss_ticket_number,
          i_item_sk
   FROM filtered_sales_items
   WHERE ss_list_price BETWEEN 236 AND 250
     AND i_manager_id BETWEEN 77 AND 96)
SELECT s1.i_item_sk,
       s2.i_item_sk,
       count(*) AS cnt
FROM sales1 s1
JOIN sales2 s2 ON s1.ss_ticket_number = s2.ss_ticket_number
WHERE s1.i_item_sk < s2.i_item_sk
GROUP BY s1.i_item_sk,
         s2.i_item_sk
ORDER BY cnt;