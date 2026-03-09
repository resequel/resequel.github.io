WITH valid_tickets AS
  (SELECT DISTINCT s.ss_ticket_number
   FROM store_sales s
   JOIN date_dim d ON s.ss_sold_date_sk = d.d_date_sk
   JOIN customer c ON s.ss_customer_sk = c.c_customer_sk
   JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   WHERE d.d_year BETWEEN 1998 AND 1998 + 1
     AND cd.cd_marital_status = 'W'
     AND cd.cd_education_status = 'Primary')
SELECT s1.ss_item_sk,
       s2.ss_item_sk,
       count(*) AS cnt
FROM store_sales s1
JOIN valid_tickets vt ON s1.ss_ticket_number = vt.ss_ticket_number
JOIN store_sales s2 ON s1.ss_ticket_number = s2.ss_ticket_number
JOIN item item1 ON s1.ss_item_sk = item1.i_item_sk
JOIN item item2 ON s2.ss_item_sk = item2.i_item_sk
WHERE s1.ss_item_sk < s2.ss_item_sk
  AND s1.ss_list_price BETWEEN 236 AND 250
  AND s2.ss_list_price BETWEEN 236 AND 250
  AND item1.i_category IN ('Jewelry',
                           'Music')
  AND item2.i_manager_id BETWEEN 77 AND 96
GROUP BY s1.ss_item_sk,
         s2.ss_item_sk
ORDER BY cnt;