
SELECT item1.i_item_sk,
       item2.i_item_sk,
       count(*) AS cnt
FROM date_dim
JOIN store_sales AS s1 ON d_date_sk = s1.ss_sold_date_sk
JOIN customer ON s1.ss_customer_sk = c_customer_sk
JOIN customer_demographics ON c_current_cdemo_sk = cd_demo_sk
JOIN customer_address ON c_current_addr_sk = ca_address_sk
JOIN item AS item1 ON s1.ss_item_sk = item1.i_item_sk
JOIN store_sales AS s2 ON s1.ss_ticket_number = s2.ss_ticket_number
JOIN item AS item2 ON s2.ss_item_sk = item2.i_item_sk
WHERE item1.i_item_sk < item2.i_item_sk
  AND d_year BETWEEN 1998 AND 1998 + 1
  AND item1.i_category IN ('Jewelry',
                           'Music')
  AND item2.i_manager_id BETWEEN 77 AND 96
  AND cd_marital_status = 'W'
  AND cd_education_status = 'Primary'
  AND s1.ss_list_price BETWEEN 236 AND 250
  AND s2.ss_list_price BETWEEN 236 AND 250
GROUP BY item1.i_item_sk,
         item2.i_item_sk
ORDER BY cnt;