WITH sales1 AS
  (SELECT ss_ticket_number,
          ss_item_sk
   FROM store_sales s1
   JOIN item i1 ON s1.ss_item_sk = i1.i_item_sk
   WHERE s1.ss_list_price BETWEEN 236 AND 250
     AND i1.i_category IN ('Jewelry',
                           'Music')
     AND EXISTS
       (SELECT 1
        FROM date_dim d
        WHERE s1.ss_sold_date_sk = d.d_date_sk
          AND d.d_year BETWEEN 1998 AND 1998 + 1)
     AND EXISTS
       (SELECT 1
        FROM customer c
        JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
        WHERE s1.ss_customer_sk = c.c_customer_sk
          AND cd.cd_marital_status = 'W'
          AND cd.cd_education_status = 'Primary')),
     sales2 AS
  (SELECT ss_ticket_number,
          ss_item_sk
   FROM store_sales s2
   JOIN item i2 ON s2.ss_item_sk = i2.i_item_sk
   WHERE s2.ss_list_price BETWEEN 236 AND 250
     AND i2.i_manager_id BETWEEN 77 AND 96
     AND EXISTS
       (SELECT 1
        FROM date_dim d
        WHERE s2.ss_sold_date_sk = d.d_date_sk
          AND d.d_year BETWEEN 1998 AND 1998 + 1)
     AND EXISTS
       (SELECT 1
        FROM customer c
        JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
        WHERE s2.ss_customer_sk = c.c_customer_sk
          AND cd.cd_marital_status = 'W'
          AND cd.cd_education_status = 'Primary'))
SELECT s1.ss_item_sk,
       s2.ss_item_sk,
       count(*) AS cnt
FROM sales1 s1
JOIN sales2 s2 ON s1.ss_ticket_number = s2.ss_ticket_number
WHERE s1.ss_item_sk < s2.ss_item_sk
GROUP BY s1.ss_item_sk,
         s2.ss_item_sk
ORDER BY cnt;