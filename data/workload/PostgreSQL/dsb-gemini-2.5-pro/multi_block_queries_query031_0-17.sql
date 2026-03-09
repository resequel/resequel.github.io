WITH ss_filtered AS
  (SELECT ca_county,
          d_qoy,
          d_year,
          sum(ss_ext_sales_price) AS store_sales
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
            d_qoy,
            d_year),
     ws_filtered AS
  (SELECT ca_county,
          d_qoy,
          d_year,
          sum(ws_ext_sales_price) AS web_sales
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
            d_qoy,
            d_year)
SELECT ss1.ca_county,
       ss1.d_year,
       ws2.web_sales / ws1.web_sales AS web_q1_q2_increase,
       ss2.store_sales / ss1.store_sales AS store_q1_q2_increase,
       ws3.web_sales / ws2.web_sales AS web_q2_q3_increase,
       ss3.store_sales / ss2.store_sales AS store_q2_q3_increase
FROM
  (SELECT *
   FROM ss_filtered
   WHERE d_qoy = 1) ss1
JOIN
  (SELECT *
   FROM ss_filtered
   WHERE d_qoy = 2) ss2 ON ss1.ca_county = ss2.ca_county
AND ss1.d_year = ss2.d_year
JOIN
  (SELECT *
   FROM ss_filtered
   WHERE d_qoy = 3) ss3 ON ss2.ca_county = ss3.ca_county
AND ss2.d_year = ss3.d_year
JOIN
  (SELECT *
   FROM ws_filtered
   WHERE d_qoy = 1) ws1 ON ss1.ca_county = ws1.ca_county
AND ss1.d_year = ws1.d_year
JOIN
  (SELECT *
   FROM ws_filtered
   WHERE d_qoy = 2) ws2 ON ws1.ca_county = ws2.ca_county
AND ws1.d_year = ws2.d_year
JOIN
  (SELECT *
   FROM ws_filtered
   WHERE d_qoy = 3) ws3 ON ws2.ca_county = ws3.ca_county
AND ws2.d_year = ws3.d_year
WHERE CASE
          WHEN ws1.web_sales > 0 THEN ws2.web_sales / ws1.web_sales
          ELSE NULL
      END > CASE
                WHEN ss1.store_sales > 0 THEN ss2.store_sales / ss1.store_sales
                ELSE NULL
            END
  AND CASE
          WHEN ws2.web_sales > 0 THEN ws3.web_sales / ws2.web_sales
          ELSE NULL
      END > CASE
                WHEN ss2.store_sales > 0 THEN ss3.store_sales / ss2.store_sales
                ELSE NULL
            END
ORDER BY store_q1_q2_increase;