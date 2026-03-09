WITH qualified_sales AS
  (SELECT ss_ticket_number,
          ss_item_sk,
          1 AS sales_type
   FROM store_sales
   JOIN item ON ss_item_sk = i_item_sk
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   JOIN customer ON ss_customer_sk = c_customer_sk
   JOIN customer_demographics ON c_current_cdemo_sk = cd_demo_sk
   JOIN customer_address ON c_current_addr_sk = ca_address_sk
   WHERE i_category IN ('Jewelry',
                           'Music')
     AND ss_list_price BETWEEN 236 AND 250
     AND d_year BETWEEN 1998 AND 1998 + 1
     AND cd_marital_status = 'W'
     AND cd_education_status = 'Primary'
   UNION ALL SELECT ss_ticket_number,
                    ss_item_sk,
                    2 AS sales_type
   FROM store_sales
   JOIN item ON ss_item_sk = i_item_sk
   WHERE i_manager_id BETWEEN 77 AND 96
     AND ss_list_price BETWEEN 236 AND 250)
SELECT min(s1.ss_item_sk),
       min(s2.ss_item_sk),
       min(s1.ss_ticket_number),
       min(s1.ss_item_sk)
FROM qualified_sales s1
JOIN qualified_sales s2 ON s1.ss_ticket_number = s2.ss_ticket_number
WHERE s1.sales_type = 1
  AND s2.sales_type = 2
  AND s1.ss_item_sk < s2.ss_item_sk;