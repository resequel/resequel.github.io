WITH combined_sales AS
  (SELECT 'store' AS sale_type,
          ca_county,
          d_year,
          d_qoy,
          ss_ext_sales_price AS sales
   FROM store_sales
   JOIN item ON ss_item_sk = i_item_sk
   JOIN customer_address ON ss_addr_sk = ca_address_sk
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   WHERE i_color IN ('purple',
                     'sandy')
     AND i_manager_id BETWEEN 36 AND 55
     AND ss_list_price BETWEEN 77 AND 91
     AND ca_state IN ('GA',
                      'IL')
     AND ((d_year = 2001
           AND d_qoy = 1)
          OR (d_year = 2001
              AND d_qoy = 2)
          OR (d_year = 2001
              AND d_qoy = 3))
   UNION ALL SELECT 'web' AS sale_type,
                    ca_county,
                    d_year,
                    d_qoy,
                    ws_ext_sales_price AS sales
   FROM web_sales
   JOIN item ON ws_item_sk = i_item_sk
   JOIN customer_address ON ws_bill_addr_sk = ca_address_sk
   JOIN date_dim ON ws_sold_date_sk = d_date_sk
   WHERE i_color IN ('purple',
                     'sandy')
     AND i_manager_id BETWEEN 36 AND 55
     AND ws_list_price BETWEEN 77 AND 91
     AND ca_state IN ('GA',
                      'IL')
     AND ((d_year = 2001
           AND d_qoy = 1)
          OR (d_year = 2001
              AND d_qoy = 2)
          OR (d_year = 2001
              AND d_qoy = 3))),
     quarterly_sales AS
  (SELECT ca_county,
          SUM(CASE
                  WHEN sale_type = 'store'
                       AND d_year = 2001
                       AND d_qoy = 1 THEN sales
                  ELSE 0
              END) AS ss1,
          SUM(CASE
                  WHEN sale_type = 'store'
                       AND d_year = 2001
                       AND d_qoy = 2 THEN sales
                  ELSE 0
              END) AS ss2,
          SUM(CASE
                  WHEN sale_type = 'store'
                       AND d_year = 2001
                       AND d_qoy = 3 THEN sales
                  ELSE 0
              END) AS ss3,
          SUM(CASE
                  WHEN sale_type = 'web'
                       AND d_year = 2001
                       AND d_qoy = 1 THEN sales
                  ELSE 0
              END) AS ws1,
          SUM(CASE
                  WHEN sale_type = 'web'
                       AND d_year = 2001
                       AND d_qoy = 2 THEN sales
                  ELSE 0
              END) AS ws2,
          SUM(CASE
                  WHEN sale_type = 'web'
                       AND d_year = 2001
                       AND d_qoy = 3 THEN sales
                  ELSE 0
              END) AS ws3
   FROM combined_sales
   GROUP BY ca_county)
SELECT ca_county, 2001 AS d_year,
                     ws2 / NULLIF(ws1, 0) AS web_q1_q2_increase,
                     ss2 / NULLIF(ss1, 0) AS store_q1_q2_increase,
                     ws3 / NULLIF(ws2, 0) AS web_q2_q3_increase,
                     ss3 / NULLIF(ss2, 0) AS store_q2_q3_increase
FROM quarterly_sales
WHERE CASE
          WHEN ws1 > 0 THEN ws2 / ws1
          ELSE NULL
      END > CASE
                WHEN ss1 > 0 THEN ss2 / ss1
                ELSE NULL
            END
  AND CASE
          WHEN ws2 > 0 THEN ws3 / ws2
          ELSE NULL
      END > CASE
                WHEN ss2 > 0 THEN ss3 / ss2
                ELSE NULL
            END
ORDER BY store_q1_q2_increase;