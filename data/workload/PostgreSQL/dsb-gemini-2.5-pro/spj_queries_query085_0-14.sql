
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
          cd1.cd_demo_sk AS cd1_sk,
          cd2.cd_demo_sk AS cd2_sk
   FROM web_sales ws
   JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN web_returns wr ON ws.ws_item_sk = wr.ws_item_sk
   AND ws.ws_order_number = wr.ws_order_number
   JOIN customer_demographics cd1 ON wr.wr_refunded_cdemo_sk = cd1.cd_demo_sk
   JOIN customer_demographics cd2 ON wr.wr_returning_cdemo_sk = cd2.cd_demo_sk
   JOIN customer_address ca ON wr.wr_refunded_addr_sk = ca.ca_address_sk
   WHERE d.d_year = 1998
     AND cd1.cd_marital_status = 'W'
     AND cd1.cd_education_status = '2 yr Degree'
     AND cd2.cd_marital_status = 'W'
     AND cd2.cd_education_status = '2 yr Degree'
     AND ws.ws_sales_price BETWEEN 100.00 AND 150.00
     AND ca.ca_country = 'United States'
     AND ca.ca_state IN ('GA',
                         'IN',
                         'VA')
     AND ws.ws_net_profit BETWEEN 100 AND 200
   UNION ALL SELECT ws.ws_quantity,
                    wr.wr_refunded_cash,
                    wr.wr_fee,
                    ws.ws_item_sk,
                    wr.wr_order_number,
                    cd1.cd_demo_sk,
                    cd2.cd_demo_sk
   FROM web_sales ws
   JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN web_returns wr ON ws.ws_item_sk = wr.ws_item_sk
   AND ws.ws_order_number = wr.ws_order_number
   JOIN customer_demographics cd1 ON wr.wr_refunded_cdemo_sk = cd1.cd_demo_sk
   JOIN customer_demographics cd2 ON wr.wr_returning_cdemo_sk = cd2.cd_demo_sk
   JOIN customer_address ca ON wr.wr_refunded_addr_sk = ca.ca_address_sk
   WHERE d.d_year = 1998
     AND cd1.cd_marital_status = 'W'
     AND cd1.cd_education_status = '2 yr Degree'
     AND cd2.cd_marital_status = 'W'
     AND cd2.cd_education_status = '2 yr Degree'
     AND ws.ws_sales_price BETWEEN 100.00 AND 150.00
     AND ca.ca_country = 'United States'
     AND ca.ca_state IN ('MT',
                            'NM',
                            'OR')
     AND ws.ws_net_profit BETWEEN 150 AND 300
   UNION ALL SELECT ws.ws_quantity,
                    wr.wr_refunded_cash,
                    wr.wr_fee,
                    ws.ws_item_sk,
                    wr.wr_order_number,
                    cd1.cd_demo_sk,
                    cd2.cd_demo_sk
   FROM web_sales ws
   JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN web_returns wr ON ws.ws_item_sk = wr.ws_item_sk
   AND ws.ws_order_number = wr.ws_order_number
   JOIN customer_demographics cd1 ON wr.wr_refunded_cdemo_sk = cd1.cd_demo_sk
   JOIN customer_demographics cd2 ON wr.wr_returning_cdemo_sk = cd2.cd_demo_sk
   JOIN customer_address ca ON wr.wr_refunded_addr_sk = ca.ca_address_sk
   WHERE d.d_year = 1998
     AND cd1.cd_marital_status = 'S'
     AND cd1.cd_education_status = 'College'
     AND cd2.cd_marital_status = 'S'
     AND cd2.cd_education_status = 'College'
     AND ws.ws_sales_price BETWEEN 50.00 AND 100.00
     AND ca.ca_country = 'United States'
     AND ca.ca_state IN ('GA',
                         'IN',
                         'VA')
     AND ws.ws_net_profit BETWEEN 100 AND 200) AS results;