WITH filtered_customers_and_dates AS
  (SELECT ss_ticket_number,
          ss_item_sk,
          ss_list_price
   FROM store_sales
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   JOIN customer ON ss_customer_sk = c_customer_sk
   JOIN customer_demographics ON c_current_cdemo_sk = cd_demo_sk
   JOIN customer_address ON c_current_addr_sk = ca_address_sk
   WHERE d_year BETWEEN 1998 AND 1998 + 1
     AND cd_marital_status = 'W'
     AND cd_education_status = 'Primary')
SELECT item1.i_item_sk,
       item2.i_item_sk,
       count(*) AS cnt
FROM filtered_customers_and_dates s1
JOIN store_sales s2 ON s1.ss_ticket_number = s2.ss_ticket_number
JOIN item item1 ON s1.ss_item_sk = item1.i_item_sk
JOIN item item2 ON s2.ss_item_sk = item2.i_item_sk
WHERE item1.i_item_sk < item2.i_item_sk
  AND s1.ss_list_price BETWEEN 236 AND 250
  AND s2.ss_list_price BETWEEN 236 AND 250
  AND item1.i_category IN ('Jewelry',
                           'Music')
  AND item2.i_manager_id BETWEEN 77 AND 96
GROUP BY item1.i_item_sk,
         item2.i_item_sk
ORDER BY cnt;