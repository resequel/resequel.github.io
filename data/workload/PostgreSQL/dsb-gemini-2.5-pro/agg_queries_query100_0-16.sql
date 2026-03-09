WITH filtered_sales_items AS
  (SELECT ss_ticket_number,
          i.i_item_sk,
          (CASE
               WHEN ss_list_price BETWEEN 236 AND 250
                    AND i.i_category IN ('Jewelry',
                           'Music') THEN 1
               ELSE 0
           END) AS is_item1,
          (CASE
               WHEN ss_list_price BETWEEN 236 AND 250
                    AND i.i_manager_id BETWEEN 77 AND 96 THEN 1
               ELSE 0
           END) AS is_item2
   FROM store_sales
   JOIN item i ON ss_item_sk = i.i_item_sk
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   JOIN customer ON ss_customer_sk = c_customer_sk
   JOIN customer_demographics ON c_current_cdemo_sk = cd_demo_sk
   WHERE d_year BETWEEN 1998 AND 1998 + 1
     AND cd_marital_status = 'W'
     AND cd_education_status = 'Primary')
SELECT s1.i_item_sk,
       s2.i_item_sk,
       count(*) AS cnt
FROM filtered_sales_items s1
JOIN filtered_sales_items s2 ON s1.ss_ticket_number = s2.ss_ticket_number
WHERE s1.is_item1 = 1
  AND s2.is_item2 = 1
  AND s1.i_item_sk < s2.i_item_sk
GROUP BY s1.i_item_sk,
         s2.i_item_sk
ORDER BY cnt;