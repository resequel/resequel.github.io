WITH ss_pivoted AS
  (SELECT ca_county,
          d_year,
          SUM(CASE
                  WHEN d_qoy = 1 THEN ss_ext_sales_price
                  ELSE 0
              END) AS sales_q1,
          SUM(CASE
                  WHEN d_qoy = 2 THEN ss_ext_sales_price
                  ELSE 0
              END) AS sales_q2,
          SUM(CASE
                  WHEN d_qoy = 3 THEN ss_ext_sales_price
                  ELSE 0
              END) AS sales_q3
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
   GROUP BY ca_county,
            d_year),
     ws_pivoted AS
  (SELECT ca_county,
          d_year,
          SUM(CASE
                  WHEN d_qoy = 1 THEN ws_ext_sales_price
                  ELSE 0
              END) AS sales_q1,
          SUM(CASE
                  WHEN d_qoy = 2 THEN ws_ext_sales_price
                  ELSE 0
              END) AS sales_q2,
          SUM(CASE
                  WHEN d_qoy = 3 THEN ws_ext_sales_price
                  ELSE 0
              END) AS sales_q3
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
                      'IL')
   GROUP BY ca_county,
            d_year)
SELECT *
FROM
  (SELECT ss.ca_county,
          ss.d_year,
          ws.sales_q2 / ws.sales_q1 AS web_q1_q2_increase,
          ss.sales_q2 / ss.sales_q1 AS store_q1_q2_increase,
          ws.sales_q3 / ws.sales_q2 AS web_q2_q3_increase,
          ss.sales_q3 / ss.sales_q2 AS store_q2_q3_increase,
          CASE
              WHEN ws.sales_q1 > 0 THEN ws.sales_q2 / ws.sales_q1
              ELSE NULL
          END AS web_ratio_1,
          CASE
              WHEN ss.sales_q1 > 0 THEN ss.sales_q2 / ss.sales_q1
              ELSE NULL
          END AS store_ratio_1,
          CASE
              WHEN ws.sales_q2 > 0 THEN ws.sales_q3 / ws.sales_q2
              ELSE NULL
          END AS web_ratio_2,
          CASE
              WHEN ss.sales_q2 > 0 THEN ss.sales_q3 / ss.sales_q2
              ELSE NULL
          END AS store_ratio_2
   FROM ss_pivoted ss
   JOIN ws_pivoted ws ON ss.ca_county = ws.ca_county
   AND ss.d_year = ws.d_year) AS ratios
WHERE web_ratio_1 > store_ratio_1
  AND web_ratio_2 > store_ratio_2
ORDER BY store_q1_q2_increase;