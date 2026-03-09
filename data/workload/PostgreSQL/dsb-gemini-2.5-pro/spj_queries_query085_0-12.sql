WITH date_dim_filtered AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 1998),
     base_sales_returns AS
  (SELECT ws.ws_item_sk,
          wr.wr_order_number,
          ws.ws_quantity,
          wr.wr_refunded_cash,
          wr.wr_fee,
          wr.wr_refunded_cdemo_sk,
          wr.wr_returning_cdemo_sk
   FROM web_sales ws
   JOIN date_dim_filtered d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN web_returns wr ON ws.ws_item_sk = wr.ws_item_sk
   AND ws.ws_order_number = wr.ws_order_number),
     demo_keys AS
  (SELECT bsr.ws_item_sk,
          bsr.wr_order_number
   FROM base_sales_returns bsr
   JOIN customer_demographics cd1 ON bsr.wr_refunded_cdemo_sk = cd1.cd_demo_sk
   JOIN customer_demographics cd2 ON bsr.wr_returning_cdemo_sk = cd2.cd_demo_sk
   WHERE cd1.cd_marital_status = cd2.cd_marital_status
     AND cd1.cd_education_status = cd2.cd_education_status
     AND ((cd1.cd_marital_status = 'W'
           AND cd1.cd_education_status = '2 yr Degree'
           AND ws_sales_price BETWEEN 100.00 AND 150.00)
          OR (cd1.cd_marital_status = 'S'
              AND cd1.cd_education_status = 'College'
              AND ws_sales_price BETWEEN 50.00 AND 100.00)
          OR (cd1.cd_marital_status = 'D'
              AND cd1.cd_education_status = 'Advanced Degree'
              AND ws_sales_price BETWEEN 150.00 AND 200.00))),
     addr_keys AS
  (SELECT bsr.ws_item_sk,
          bsr.wr_order_number
   FROM base_sales_returns bsr
   JOIN customer_address ca ON bsr.wr_refunded_addr_sk = ca.ca_address_sk
   WHERE ((ca.ca_country = 'United States'
           AND ca.ca_state IN ('GA',
                         'IN',
                         'VA')
           AND ws_net_profit BETWEEN 100 AND 200)
          OR (ca.ca_country = 'United States'
              AND ca.ca_state IN ('MT',
                            'NM',
                            'OR')
              AND ws_net_profit BETWEEN 150 AND 300)
          OR (ca.ca_country = 'United States'
              AND ca.ca_state IN ('GA',
                            'IL',
                            'OH')
              AND ws_net_profit BETWEEN 50 AND 250)))
SELECT min(bsr.ws_quantity),
       min(bsr.wr_refunded_cash),
       min(bsr.wr_fee),
       min(bsr.ws_item_sk),
       min(bsr.wr_order_number),
       min(bsr.wr_refunded_cdemo_sk),
       min(bsr.wr_returning_cdemo_sk)
FROM base_sales_returns bsr
JOIN
  (SELECT ws_item_sk,
          wr_order_number
   FROM demo_keys INTERSECT SELECT ws_item_sk,
                                   wr_order_number
   FROM addr_keys) AS final_keys ON bsr.ws_item_sk = final_keys.ws_item_sk
AND bsr.wr_order_number = final_keys.wr_order_number;