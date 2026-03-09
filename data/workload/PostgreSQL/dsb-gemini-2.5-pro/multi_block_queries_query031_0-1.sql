WITH filtered_items_ss AS
  (SELECT i_item_sk
   FROM item
   WHERE i_color IN ('purple',
                     'sandy')
     AND i_manager_id BETWEEN 36 AND 55),
     filtered_items_ws AS
  (SELECT i_item_sk
   FROM item
   WHERE i_color IN ('purple',
                     'sandy')
     AND i_manager_id BETWEEN 36 AND 55),
     filtered_addr_ss AS
  (SELECT ca_address_sk,
          ca_county
   FROM customer_address
   WHERE ca_state IN ('GA',
                      'IL')),
     filtered_addr_ws AS
  (SELECT ca_address_sk,
          ca_county
   FROM customer_address
   WHERE ca_state IN ('GA',
                      'IL')),
     ss_pivoted AS
  (SELECT fa.ca_county,
          d.d_year,
          SUM(CASE
                  WHEN d.d_qoy = 1 THEN ss.ss_ext_sales_price
                  ELSE 0
              END) AS sales_q1,
          SUM(CASE
                  WHEN d.d_qoy = 2 THEN ss.ss_ext_sales_price
                  ELSE 0
              END) AS sales_q2,
          SUM(CASE
                  WHEN d.d_qoy = 3 THEN ss.ss_ext_sales_price
                  ELSE 0
              END) AS sales_q3
   FROM store_sales ss
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN filtered_addr_ss fa ON ss.ss_addr_sk = fa.ca_address_sk
   JOIN filtered_items_ss fi ON ss.ss_item_sk = fi.i_item_sk
   WHERE d.d_year = 2001
     AND d.d_qoy IN (1, 2, 3)
     AND ss.ss_list_price BETWEEN 77 AND 91
   GROUP BY fa.ca_county,
            d.d_year),
     ws_pivoted AS
  (SELECT fa.ca_county,
          d.d_year,
          SUM(CASE
                  WHEN d.d_qoy = 1 THEN ws.ws_ext_sales_price
                  ELSE 0
              END) AS sales_q1,
          SUM(CASE
                  WHEN d.d_qoy = 2 THEN ws.ws_ext_sales_price
                  ELSE 0
              END) AS sales_q2,
          SUM(CASE
                  WHEN d.d_qoy = 3 THEN ws.ws_ext_sales_price
                  ELSE 0
              END) AS sales_q3
   FROM web_sales ws
   JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN filtered_addr_ws fa ON ws.ws_bill_addr_sk = fa.ca_address_sk
   JOIN filtered_items_ws fi ON ws.ws_item_sk = fi.i_item_sk
   WHERE d.d_year = 2001
     AND d.d_qoy IN (1, 2, 3)
     AND ws.ws_list_price BETWEEN 77 AND 91
   GROUP BY fa.ca_county,
            d.d_year)
SELECT ss.ca_county,
       ss.d_year,
       ws.sales_q2 / ws.sales_q1 AS web_q1_q2_increase,
       ss.sales_q2 / ss.sales_q1 AS store_q1_q2_increase,
       ws.sales_q3 / ws.sales_q2 AS web_q2_q3_increase,
       ss.sales_q3 / ss.sales_q2 AS store_q2_q3_increase
FROM ss_pivoted ss
JOIN ws_pivoted ws ON ss.ca_county = ws.ca_county
AND ss.d_year = ws.d_year
WHERE CASE
          WHEN ws.sales_q1 > 0 THEN ws.sales_q2 / ws.sales_q1
          ELSE NULL
      END > CASE
                WHEN ss.sales_q1 > 0 THEN ss.sales_q2 / ss.sales_q1
                ELSE NULL
            END
  AND CASE
          WHEN ws.sales_q2 > 0 THEN ws.sales_q3 / ws.sales_q2
          ELSE NULL
      END > CASE
                WHEN ss.sales_q2 > 0 THEN ss.sales_q3 / ss.sales_q2
                ELSE NULL
            END
ORDER BY store_q1_q2_increase;