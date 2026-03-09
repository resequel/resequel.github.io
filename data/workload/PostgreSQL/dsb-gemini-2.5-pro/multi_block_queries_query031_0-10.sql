WITH all_sales AS
  (SELECT ca_county,
          d_year,
          d_qoy,
          ss_ext_sales_price AS store_sales,
          0.0 AS web_sales
   FROM store_sales
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   JOIN customer_address ON ss_addr_sk = ca_address_sk
   JOIN item ON ss_item_sk = i_item_sk
   WHERE d_year = 2001
     AND d_qoy IN (1, 2, 3)
     AND i_color IN ('purple',
                     'sandy')
     AND i_manager_id BETWEEN 36 AND 55
     AND ss_list_price BETWEEN 77 AND 91
     AND ca_state IN ('GA',
                      'IL')
   UNION ALL SELECT ca_county,
                    d_year,
                    d_qoy,
                    0.0,
                    ws_ext_sales_price
   FROM web_sales
   JOIN date_dim ON ws_sold_date_sk = d_date_sk
   JOIN customer_address ON ws_bill_addr_sk = ca_address_sk
   JOIN item ON ws_item_sk = i_item_sk
   WHERE d_year = 2001
     AND d_qoy IN (1, 2, 3)
     AND i_color IN ('purple',
                     'sandy')
     AND i_manager_id BETWEEN 36 AND 55
     AND ws_list_price BETWEEN 77 AND 91
     AND ca_state IN ('GA',
                      'IL')),
     pivoted_sales AS
  (SELECT ca_county,
          d_year,
          SUM(CASE
                  WHEN d_qoy = 1 THEN store_sales
                  ELSE 0
              END) AS ss1,
          SUM(CASE
                  WHEN d_qoy = 2 THEN store_sales
                  ELSE 0
              END) AS ss2,
          SUM(CASE
                  WHEN d_qoy = 3 THEN store_sales
                  ELSE 0
              END) AS ss3,
          SUM(CASE
                  WHEN d_qoy = 1 THEN web_sales
                  ELSE 0
              END) AS ws1,
          SUM(CASE
                  WHEN d_qoy = 2 THEN web_sales
                  ELSE 0
              END) AS ws2,
          SUM(CASE
                  WHEN d_qoy = 3 THEN web_sales
                  ELSE 0
              END) AS ws3
   FROM all_sales
   GROUP BY ca_county,
            d_year)
SELECT ca_county,
       d_year,
       ws2 / ws1 AS web_q1_q2_increase,
       ss2 / ss1 AS store_q1_q2_increase,
       ws3 / ws2 AS web_q2_q3_increase,
       ss3 / ss2 AS store_q2_q3_increase
FROM pivoted_sales
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