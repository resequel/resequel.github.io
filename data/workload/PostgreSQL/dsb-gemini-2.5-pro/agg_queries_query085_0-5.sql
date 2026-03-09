WITH demo_filtered_returns AS
  (SELECT ws_item_sk,
          ws_order_number,
          ws_quantity,
          wr_refunded_cash,
          wr_fee,
          wr_refunded_addr_sk,
          r_reason_sk
   FROM web_sales
   JOIN web_returns ON ws_item_sk = wr_item_sk
   AND ws_order_number = wr_order_number
   JOIN date_dim ON ws_sold_date_sk = d_date_sk
   JOIN customer_demographics cd1 ON wr_refunded_cdemo_sk = cd1.cd_demo_sk
   JOIN customer_demographics cd2 ON wr_returning_cdemo_sk = cd2.cd_demo_sk
   WHERE d_year = 1998
     AND cd1.cd_marital_status = cd2.cd_marital_status
     AND cd1.cd_education_status = cd2.cd_education_status
     AND cd1.cd_marital_status = 'W'
     AND cd1.cd_education_status = '2 yr Degree'
     AND ws_sales_price BETWEEN 100.00 AND 150.00
   UNION ALL SELECT ws_item_sk,
                    ws_order_number,
                    ws_quantity,
                    wr_refunded_cash,
                    wr_fee,
                    wr_refunded_addr_sk,
                    r_reason_sk
   FROM web_sales
   JOIN web_returns ON ws_item_sk = wr_item_sk
   AND ws_order_number = wr_order_number
   JOIN date_dim ON ws_sold_date_sk = d_date_sk
   JOIN customer_demographics cd1 ON wr_refunded_cdemo_sk = cd1.cd_demo_sk
   JOIN customer_demographics cd2 ON wr_returning_cdemo_sk = cd2.cd_demo_sk
   WHERE d_year = 1998
     AND cd1.cd_marital_status = cd2.cd_marital_status
     AND cd1.cd_education_status = cd2.cd_education_status
     AND cd1.cd_marital_status = 'S'
     AND cd1.cd_education_status = 'College'
     AND ws_sales_price BETWEEN 50.00 AND 100.00
   UNION ALL SELECT ws_item_sk,
                    ws_order_number,
                    ws_quantity,
                    wr_refunded_cash,
                    wr_fee,
                    wr_refunded_addr_sk,
                    r_reason_sk
   FROM web_sales
   JOIN web_returns ON ws_item_sk = wr_item_sk
   AND ws_order_number = wr_order_number
   JOIN date_dim ON ws_sold_date_sk = d_date_sk
   JOIN customer_demographics cd1 ON wr_refunded_cdemo_sk = cd1.cd_demo_sk
   JOIN customer_demographics cd2 ON wr_returning_cdemo_sk = cd2.cd_demo_sk
   WHERE d_year = 1998
     AND cd1.cd_marital_status = cd2.cd_marital_status
     AND cd1.cd_education_status = cd2.cd_education_status
     AND cd1.cd_marital_status = 'D'
     AND cd1.cd_education_status = 'Advanced Degree'
     AND ws_sales_price BETWEEN 150.00 AND 200.00)
SELECT substring(r_reason_desc, 1, 20),
       avg(dfr.ws_quantity),
       avg(dfr.wr_refunded_cash),
       avg(dfr.wr_fee)
FROM demo_filtered_returns dfr
JOIN customer_address ON dfr.wr_refunded_addr_sk = ca_address_sk
JOIN reason ON dfr.r_reason_sk = r_reason_sk
JOIN web_sales ON dfr.ws_item_sk = web_sales.ws_item_sk
AND dfr.ws_order_number = web_sales.ws_order_number
WHERE ((ca_country = 'United States'
        AND ca_state IN ('GA',
                         'IN',
                         'VA')
        AND ws_net_profit BETWEEN 100 AND 200)
       OR (ca_country = 'United States'
           AND ca_state IN ('MT',
                            'NM',
                            'OR')
           AND ws_net_profit BETWEEN 150 AND 300)
       OR (ca_country = 'United States'
           AND ca_state IN ('GA',
                            'IL',
                            'OH')
           AND ws_net_profit BETWEEN 50 AND 250))
GROUP BY r_reason_desc
ORDER BY substring(r_reason_desc, 1, 20),
         avg(dfr.ws_quantity),
         avg(dfr.wr_refunded_cash),
         avg(dfr.wr_fee)
LIMIT 100;