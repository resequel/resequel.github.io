WITH quarterly_sales AS
  (SELECT ca_county,
          d_year,
          d_qoy,
          SUM(ss_ext_sales_price) AS total_sales,
          'store' AS channel
   FROM store_sales,
        date_dim,
        customer_address,
        item
   WHERE ss_sold_date_sk = d_date_sk
     AND ss_addr_sk=ca_address_sk
     AND ss_item_sk = i_item_sk
     AND i_color IN ('purple',
                     'sandy')
     AND i_manager_id BETWEEN 36 AND 55
     AND ss_list_price BETWEEN 77 AND 91
     AND ca_state IN ('GA',
                      'IL')
   GROUP BY ca_county,
            d_qoy,
            d_year
   UNION ALL SELECT ca_county,
                    d_qoy,
                    d_year,
                    SUM(ws_ext_sales_price) AS total_sales,
                    'web' AS channel
   FROM web_sales,
        date_dim,
        customer_address,
        item
   WHERE ws_sold_date_sk = d_date_sk
     AND ws_bill_addr_sk=ca_address_sk
     AND ws_item_sk = i_item_sk
     AND i_color IN ('purple',
                     'sandy')
     AND i_manager_id BETWEEN 36 AND 55
     AND ws_list_price BETWEEN 77 AND 91
     AND ca_state IN ('GA',
                      'IL')
   GROUP BY ca_county,
            d_qoy,
            d_year),
     ss1 AS
  (SELECT *
   FROM quarterly_sales
   WHERE d_qoy = 1
     AND d_year = 2001
     AND channel = 'store'),
     ss2 AS
  (SELECT *
   FROM quarterly_sales
   WHERE d_qoy = 2
     AND d_year = 2001
     AND channel = 'store'),
     ss3 AS
  (SELECT *
   FROM quarterly_sales
   WHERE d_qoy = 3
     AND d_year = 2001
     AND channel = 'store'),
     ws1 AS
  (SELECT *
   FROM quarterly_sales
   WHERE d_qoy = 1
     AND d_year = 2001
     AND channel = 'web'),
     ws2 AS
  (SELECT *
   FROM quarterly_sales
   WHERE d_qoy = 2
     AND d_year = 2001
     AND channel = 'web'),
     ws3 AS
  (SELECT *
   FROM quarterly_sales
   WHERE d_qoy = 3
     AND d_year = 2001
     AND channel = 'web')
SELECT ss1.ca_county,
       ss1.d_year,
       ws2.total_sales/ws1.total_sales,
       ss2.total_sales/ss1.total_sales,
       ws3.total_sales/ws2.total_sales,
       ss3.total_sales/ss2.total_sales
FROM ss1,
     ss2,
     ss3,
     ws1,
     ws2,
     ws3
WHERE ss1.ca_county = ss2.ca_county
  AND ss2.ca_county = ss3.ca_county
  AND ss1.ca_county = ws1.ca_county
  AND ws1.ca_county = ws2.ca_county
  AND ws2.ca_county = ws3.ca_county
  AND CASE
          WHEN ws1.total_sales > 0 THEN ws2.total_sales/ws1.total_sales
          ELSE NULL
      END > CASE
                WHEN ss1.total_sales > 0 THEN ss2.total_sales/ss1.total_sales
                ELSE NULL
            END
  AND CASE
          WHEN ws2.total_sales > 0 THEN ws3.total_sales/ws2.total_sales
          ELSE NULL
      END > CASE
                WHEN ss2.total_sales > 0 THEN ss3.total_sales/ss2.total_sales
                ELSE NULL
            END
ORDER BY 4;