WITH date_dim_filtered AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 1998),
     cd_filtered_1 AS
  (SELECT cd_demo_sk
   FROM customer_demographics
   WHERE cd_marital_status = 'W'
     AND cd_education_status = '2 yr Degree'),
     cd_filtered_2 AS
  (SELECT cd_demo_sk
   FROM customer_demographics
   WHERE cd_marital_status = 'S'
     AND cd_education_status = 'College'),
     cd_filtered_3 AS
  (SELECT cd_demo_sk
   FROM customer_demographics
   WHERE cd_marital_status = 'D'
     AND cd_education_status = 'Advanced Degree'),
     ca_filtered_1 AS
  (SELECT ca_address_sk
   FROM customer_address
   WHERE ca_country = 'United States'
     AND ca_state IN ('GA',
                         'IN',
                         'VA')),
     ca_filtered_2 AS
  (SELECT ca_address_sk
   FROM customer_address
   WHERE ca_country = 'United States'
     AND ca_state IN ('MT',
                            'NM',
                            'OR')),
     ca_filtered_3 AS
  (SELECT ca_address_sk
   FROM customer_address
   WHERE ca_country = 'United States'
     AND ca_state IN ('GA',
                            'IL',
                            'OH'))
SELECT min(ws_quantity),
       min(wr_refunded_cash),
       min(wr_fee),
       min(ws_item_sk),
       min(wr_order_number),
       min(cd1_sk),
       min(cd2_sk)
FROM
  (SELECT ws.ws_quantity,
          wr.wr_refunded_cash,
          wr.wr_fee,
          ws.ws_item_sk,
          wr.wr_order_number,
          wr.wr_refunded_cdemo_sk AS cd1_sk,
          wr.wr_returning_cdemo_sk AS cd2_sk
   FROM web_sales ws
   JOIN date_dim_filtered d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN web_returns wr ON ws.ws_item_sk = wr.ws_item_sk
   AND ws.ws_order_number = wr.ws_order_number
   JOIN cd_filtered_1 ON wr.wr_refunded_cdemo_sk = cd_filtered_1.cd_demo_sk
   JOIN cd_filtered_1 AS cd2 ON wr.wr_returning_cdemo_sk = cd2.cd_demo_sk
   JOIN ca_filtered_1 ON wr.wr_refunded_addr_sk = ca_filtered_1.ca_address_sk
   WHERE ws.ws_sales_price BETWEEN 100.00 AND 150.00
     AND ws.ws_net_profit BETWEEN 100 AND 200
   UNION ALL SELECT ws.ws_quantity,
                    wr.wr_refunded_cash,
                    wr.wr_fee,
                    ws.ws_item_sk,
                    wr.wr_order_number,
                    wr.wr_refunded_cdemo_sk,
                    wr.wr_returning_cdemo_sk
   FROM web_sales ws
   JOIN date_dim_filtered d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN web_returns wr ON ws.ws_item_sk = wr.ws_item_sk
   AND ws.ws_order_number = wr.ws_order_number
   JOIN cd_filtered_1 ON wr.wr_refunded_cdemo_sk = cd_filtered_1.cd_demo_sk
   JOIN cd_filtered_1 AS cd2 ON wr.wr_returning_cdemo_sk = cd2.cd_demo_sk
   JOIN ca_filtered_2 ON wr.wr_refunded_addr_sk = ca_filtered_2.ca_address_sk
   WHERE ws.ws_sales_price BETWEEN 100.00 AND 150.00
     AND ws.ws_net_profit BETWEEN 150 AND 300
   UNION ALL SELECT ws.ws_quantity,
                    wr.wr_refunded_cash,
                    wr.wr_fee,
                    ws.ws_item_sk,
                    wr.wr_order_number,
                    wr.wr_refunded_cdemo_sk,
                    wr.wr_returning_cdemo_sk
   FROM web_sales ws
   JOIN date_dim_filtered d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN web_returns wr ON ws.ws_item_sk = wr.ws_item_sk
   AND ws.ws_order_number = wr.ws_order_number
   JOIN cd_filtered_1 ON wr.wr_refunded_cdemo_sk = cd_filtered_1.cd_demo_sk
   JOIN cd_filtered_1 AS cd2 ON wr.wr_returning_cdemo_sk = cd2.cd_demo_sk
   JOIN ca_filtered_3 ON wr.wr_refunded_addr_sk = ca_filtered_3.ca_address_sk
   WHERE ws.ws_sales_price BETWEEN 100.00 AND 150.00
     AND ws.ws_net_profit BETWEEN 50 AND 250
   UNION ALL SELECT ws.ws_quantity,
                    wr.wr_refunded_cash,
                    wr.wr_fee,
                    ws.ws_item_sk,
                    wr.wr_order_number,
                    wr.wr_refunded_cdemo_sk,
                    wr.wr_returning_cdemo_sk
   FROM web_sales ws
   JOIN date_dim_filtered d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN web_returns wr ON ws.ws_item_sk = wr.ws_item_sk
   AND ws.ws_order_number = wr.ws_order_number
   JOIN cd_filtered_2 ON wr.wr_refunded_cdemo_sk = cd_filtered_2.cd_demo_sk
   JOIN cd_filtered_2 AS cd2 ON wr.wr_returning_cdemo_sk = cd2.cd_demo_sk
   JOIN ca_filtered_1 ON wr.wr_refunded_addr_sk = ca_filtered_1.ca_address_sk
   WHERE ws.ws_sales_price BETWEEN 50.00 AND 100.00
     AND ws.ws_net_profit BETWEEN 100 AND 200
   UNION ALL SELECT ws.ws_quantity,
                    wr.wr_refunded_cash,
                    wr.wr_fee,
                    ws.ws_item_sk,
                    wr.wr_order_number,
                    wr.wr_refunded_cdemo_sk,
                    wr.wr_returning_cdemo_sk
   FROM web_sales ws
   JOIN date_dim_filtered d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN web_returns wr ON ws.ws_item_sk = wr.ws_item_sk
   AND ws.ws_order_number = wr.ws_order_number
   JOIN cd_filtered_2 ON wr.wr_refunded_cdemo_sk = cd_filtered_2.cd_demo_sk
   JOIN cd_filtered_2 AS cd2 ON wr.wr_returning_cdemo_sk = cd2.cd_demo_sk
   JOIN ca_filtered_2 ON wr.wr_refunded_addr_sk = ca_filtered_2.ca_address_sk
   WHERE ws.ws_sales_price BETWEEN 50.00 AND 100.00
     AND ws.ws_net_profit BETWEEN 150 AND 300
   UNION ALL SELECT ws.ws_quantity,
                    wr.wr_refunded_cash,
                    wr.wr_fee,
                    ws.ws_item_sk,
                    wr.wr_order_number,
                    wr.wr_refunded_cdemo_sk,
                    wr.wr_returning_cdemo_sk
   FROM web_sales ws
   JOIN date_dim_filtered d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN web_returns wr ON ws.ws_item_sk = wr.ws_item_sk
   AND ws.ws_order_number = wr.ws_order_number
   JOIN cd_filtered_2 ON wr.wr_refunded_cdemo_sk = cd_filtered_2.cd_demo_sk
   JOIN cd_filtered_2 AS cd2 ON wr.wr_returning_cdemo_sk = cd2.cd_demo_sk
   JOIN ca_filtered_3 ON wr.wr_refunded_addr_sk = ca_filtered_3.ca_address_sk
   WHERE ws.ws_sales_price BETWEEN 50.00 AND 100.00
     AND ws.ws_net_profit BETWEEN 50 AND 250
   UNION ALL SELECT ws.ws_quantity,
                    wr.wr_refunded_cash,
                    wr.wr_fee,
                    ws.ws_item_sk,
                    wr.wr_order_number,
                    wr.wr_refunded_cdemo_sk,
                    wr.wr_returning_cdemo_sk
   FROM web_sales ws
   JOIN date_dim_filtered d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN web_returns wr ON ws.ws_item_sk = wr.ws_item_sk
   AND ws.ws_order_number = wr.ws_order_number
   JOIN cd_filtered_3 ON wr.wr_refunded_cdemo_sk = cd_filtered_3.cd_demo_sk
   JOIN cd_filtered_3 AS cd2 ON wr.wr_returning_cdemo_sk = cd2.cd_demo_sk
   JOIN ca_filtered_1 ON wr.wr_refunded_addr_sk = ca_filtered_1.ca_address_sk
   WHERE ws.ws_sales_price BETWEEN 150.00 AND 200.00
     AND ws.ws_net_profit BETWEEN 100 AND 200
   UNION ALL SELECT ws.ws_quantity,
                    wr.wr_refunded_cash,
                    wr.wr_fee,
                    ws.ws_item_sk,
                    wr.wr_order_number,
                    wr.wr_refunded_cdemo_sk,
                    wr.wr_returning_cdemo_sk
   FROM web_sales ws
   JOIN date_dim_filtered d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN web_returns wr ON ws.ws_item_sk = wr.ws_item_sk
   AND ws.ws_order_number = wr.ws_order_number
   JOIN cd_filtered_3 ON wr.wr_refunded_cdemo_sk = cd_filtered_3.cd_demo_sk
   JOIN cd_filtered_3 AS cd2 ON wr.wr_returning_cdemo_sk = cd2.cd_demo_sk
   JOIN ca_filtered_2 ON wr.wr_refunded_addr_sk = ca_filtered_2.ca_address_sk
   WHERE ws.ws_sales_price BETWEEN 150.00 AND 200.00
     AND ws.ws_net_profit BETWEEN 150 AND 300
   UNION ALL SELECT ws.ws_quantity,
                    wr.wr_refunded_cash,
                    wr.wr_fee,
                    ws.ws_item_sk,
                    wr.wr_order_number,
                    wr.wr_refunded_cdemo_sk,
                    wr.wr_returning_cdemo_sk
   FROM web_sales ws
   JOIN date_dim_filtered d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN web_returns wr ON ws.ws_item_sk = wr.ws_item_sk
   AND ws.ws_order_number = wr.ws_order_number
   JOIN cd_filtered_3 ON wr.wr_refunded_cdemo_sk = cd_filtered_3.cd_demo_sk
   JOIN cd_filtered_3 AS cd2 ON wr.wr_returning_cdemo_sk = cd2.cd_demo_sk
   JOIN ca_filtered_3 ON wr.wr_refunded_addr_sk = ca_filtered_3.ca_address_sk
   WHERE ws.ws_sales_price BETWEEN 150.00 AND 200.00
     AND ws.ws_net_profit BETWEEN 50 AND 250) AS results;