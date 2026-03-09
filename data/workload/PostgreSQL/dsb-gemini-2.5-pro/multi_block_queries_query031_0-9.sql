WITH ss_sales AS
  (SELECT ca_county,
          d_year,
          d_qoy,
          sum(ss_ext_sales_price) AS store_sales
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
     AND ((d_year = 2001
           AND d_qoy = 1)
          OR (d_year = 2001
              AND d_qoy = 2)
          OR (d_year = 2001
              AND d_qoy = 3))
   GROUP BY ca_county,
            d_qoy,
            d_year),
     ws_sales AS
  (SELECT ca_county,
          d_qoy,
          d_year,
          sum(ws_ext_sales_price) AS web_sales
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
     AND ((d_year = 2001
           AND d_qoy = 1)
          OR (d_year = 2001
              AND d_qoy = 2)
          OR (d_year = 2001
              AND d_qoy = 3))
   GROUP BY ca_county,
            d_qoy,
            d_year)
SELECT ss1.ca_county,
       ss1.d_year,
       ws2.web_sales/ws1.web_sales,
       ss2.store_sales/ss1.store_sales,
       ws3.web_sales/ws2.web_sales,
       ss3.store_sales/ss2.store_sales
FROM ss_sales ss1
JOIN ss_sales ss2 ON ss1.ca_county = ss2.ca_county
JOIN ss_sales ss3 ON ss2.ca_county = ss3.ca_county
JOIN ws_sales ws1 ON ss1.ca_county = ws1.ca_county
JOIN ws_sales ws2 ON ws1.ca_county = ws2.ca_county
JOIN ws_sales ws3 ON ws2.ca_county = ws3.ca_county
WHERE ss1.d_qoy = 1
  AND ss1.d_year = 2001
  AND ss2.d_qoy = 2
  AND ss2.d_year = 2001
  AND ss3.d_qoy = 3
  AND ss3.d_year = 2001
  AND ws1.d_qoy = 1
  AND ws1.d_year = 2001
  AND ws2.d_qoy = 2
  AND ws2.d_year = 2001
  AND ws3.d_qoy = 3
  AND ws3.d_year = 2001
  AND CASE
          WHEN ws1.web_sales > 0 THEN ws2.web_sales/ws1.web_sales
          ELSE NULL
      END > CASE
                WHEN ss1.store_sales > 0 THEN ss2.store_sales/ss1.store_sales
                ELSE NULL
            END
  AND CASE
          WHEN ws2.web_sales > 0 THEN ws3.web_sales/ws2.web_sales
          ELSE NULL
      END > CASE
                WHEN ss2.store_sales > 0 THEN ss3.store_sales/ss2.store_sales
                ELSE NULL
            END
ORDER BY 4;