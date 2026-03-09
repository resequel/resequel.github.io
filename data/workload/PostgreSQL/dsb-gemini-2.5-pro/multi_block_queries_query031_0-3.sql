WITH ss_items AS
  (SELECT i_item_sk
   FROM item
   WHERE i_color IN ('purple',
                     'sandy')
     AND i_manager_id BETWEEN 36 AND 55),
     ss_addr AS
  (SELECT ca_address_sk,
          ca_county
   FROM customer_address
   WHERE ca_state IN ('GA',
                      'IL')),
     ss_sales AS
  (SELECT ca_county,
          SUM(CASE
                  WHEN d_year = 2001
                       AND d_qoy = 1 THEN ss_ext_sales_price
                  ELSE 0
              END) AS store_q1,
          SUM(CASE
                  WHEN d_year = 2001
                       AND d_qoy = 2 THEN ss_ext_sales_price
                  ELSE 0
              END) AS store_q2,
          SUM(CASE
                  WHEN d_year = 2001
                       AND d_qoy = 3 THEN ss_ext_sales_price
                  ELSE 0
              END) AS store_q3
   FROM store_sales
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   JOIN ss_addr ON ss_addr_sk = ss_addr.ca_address_sk
   JOIN ss_items ON ss_item_sk = ss_items.i_item_sk
   WHERE ss_list_price BETWEEN 77 AND 91
     AND ((d_year = 2001
           AND d_qoy = 1)
          OR (d_year = 2001
              AND d_qoy = 2)
          OR (d_year = 2001
              AND d_qoy = 3))
   GROUP BY ca_county),
     ws_items AS
  (SELECT i_item_sk
   FROM item
   WHERE i_color IN ('purple',
                     'sandy')
     AND i_manager_id BETWEEN 36 AND 55),
     ws_addr AS
  (SELECT ca_address_sk,
          ca_county
   FROM customer_address
   WHERE ca_state IN ('GA',
                      'IL')),
     ws_sales AS
  (SELECT ca_county,
          SUM(CASE
                  WHEN d_year = 2001
                       AND d_qoy = 1 THEN ws_ext_sales_price
                  ELSE 0
              END) AS web_q1,
          SUM(CASE
                  WHEN d_year = 2001
                       AND d_qoy = 2 THEN ws_ext_sales_price
                  ELSE 0
              END) AS web_q2,
          SUM(CASE
                  WHEN d_year = 2001
                       AND d_qoy = 3 THEN ws_ext_sales_price
                  ELSE 0
              END) AS web_q3
   FROM web_sales
   JOIN date_dim ON ws_sold_date_sk = d_date_sk
   JOIN ws_addr ON ws_bill_addr_sk = ws_addr.ca_address_sk
   JOIN ws_items ON ws_item_sk = ws_items.i_item_sk
   WHERE ws_list_price BETWEEN 77 AND 91
     AND ((d_year = 2001
           AND d_qoy = 1)
          OR (d_year = 2001
              AND d_qoy = 2)
          OR (d_year = 2001
              AND d_qoy = 3))
   GROUP BY ca_county)
SELECT ss_sales.ca_county, 2001 AS d_year,
                              ws_sales.web_q2 / ws_sales.web_q1,
                              ss_sales.store_q2 / ss_sales.store_q1,
                              ws_sales.web_q3 / ws_sales.web_q2,
                              ss_sales.store_q3 / ss_sales.store_q2
FROM ss_sales
JOIN ws_sales ON ss_sales.ca_county = ws_sales.ca_county
WHERE CASE
          WHEN ws_sales.web_q1 > 0 THEN ws_sales.web_q2 / ws_sales.web_q1
          ELSE NULL
      END > CASE
                WHEN ss_sales.store_q1 > 0 THEN ss_sales.store_q2 / ss_sales.store_q1
                ELSE NULL
            END
  AND CASE
          WHEN ws_sales.web_q2 > 0 THEN ws_sales.web_q3 / ws_sales.web_q2
          ELSE NULL
      END > CASE
                WHEN ss_sales.store_q2 > 0 THEN ss_sales.store_q3 / ss_sales.store_q2
                ELSE NULL
            END
ORDER BY 2;