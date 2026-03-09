WITH filtered_data AS
  (SELECT ws.ws_quantity,
          wr.wr_refunded_cash,
          wr.wr_fee,
          r.r_reason_desc
   FROM web_sales ws
   JOIN web_returns wr ON ws.ws_item_sk = wr.wr_item_sk
   AND ws.ws_order_number = wr.wr_order_number
   JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN customer_demographics cd1 ON wr.wr_refunded_cdemo_sk = cd1.cd_demo_sk
   JOIN customer_demographics cd2 ON wr.wr_returning_cdemo_sk = cd2.cd_demo_sk
   JOIN customer_address ca ON wr.wr_refunded_addr_sk = ca.ca_address_sk
   JOIN reason r ON wr.wr_reason_sk = r.r_reason_sk
   WHERE d.d_year = 1998
     AND cd1.cd_marital_status = 'W'
     AND cd1.cd_marital_status = cd2.cd_marital_status
     AND cd1.cd_education_status = '2 yr Degree'
     AND cd1.cd_education_status = cd2.cd_education_status
     AND ws.ws_sales_price BETWEEN 100.00 AND 150.00
     AND ((ca.ca_country = 'United States'
           AND ca.ca_state IN ('GA',
                         'IN',
                         'VA')
           AND ws.ws_net_profit BETWEEN 100 AND 200)
          OR (ca.ca_country = 'United States'
              AND ca.ca_state IN ('MT',
                            'NM',
                            'OR')
              AND ws.ws_net_profit BETWEEN 150 AND 300)
          OR (ca.ca_country = 'United States'
              AND ca.ca_state IN ('GA',
                            'IL',
                            'OH')
              AND ws.ws_net_profit BETWEEN 50 AND 250))
   UNION ALL SELECT ws.ws_quantity,
                    wr.wr_refunded_cash,
                    wr.wr_fee,
                    r.r_reason_desc
   FROM web_sales ws
   JOIN web_returns wr ON ws.ws_item_sk = wr.wr_item_sk
   AND ws.ws_order_number = wr.wr_order_number
   JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN customer_demographics cd1 ON wr.wr_refunded_cdemo_sk = cd1.cd_demo_sk
   JOIN customer_demographics cd2 ON wr.wr_returning_cdemo_sk = cd2.cd_demo_sk
   JOIN customer_address ca ON wr.wr_refunded_addr_sk = ca.ca_address_sk
   JOIN reason r ON wr.wr_reason_sk = r.r_reason_sk
   WHERE d.d_year = 1998
     AND cd1.cd_marital_status = 'S'
     AND cd1.cd_marital_status = cd2.cd_marital_status
     AND cd1.cd_education_status = 'College'
     AND cd1.cd_education_status = cd2.cd_education_status
     AND ws.ws_sales_price BETWEEN 50.00 AND 100.00
     AND ((ca.ca_country = 'United States'
           AND ca.ca_state IN ('GA',
                         'IN',
                         'VA')
           AND ws.ws_net_profit BETWEEN 100 AND 200)
          OR (ca.ca_country = 'United States'
              AND ca.ca_state IN ('MT',
                            'NM',
                            'OR')
              AND ws.ws_net_profit BETWEEN 150 AND 300)
          OR (ca.ca_country = 'United States'
              AND ca.ca_state IN ('GA',
                            'IL',
                            'OH')
              AND ws.ws_net_profit BETWEEN 50 AND 250))
   UNION ALL SELECT ws.ws_quantity,
                    wr.wr_refunded_cash,
                    wr.wr_fee,
                    r.r_reason_desc
   FROM web_sales ws
   JOIN web_returns wr ON ws.ws_item_sk = wr.wr_item_sk
   AND ws.ws_order_number = wr.wr_order_number
   JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN customer_demographics cd1 ON wr.wr_refunded_cdemo_sk = cd1.cd_demo_sk
   JOIN customer_demographics cd2 ON wr.wr_returning_cdemo_sk = cd2.cd_demo_sk
   JOIN customer_address ca ON wr.wr_refunded_addr_sk = ca.ca_address_sk
   JOIN reason r ON wr.wr_reason_sk = r.r_reason_sk
   WHERE d.d_year = 1998
     AND cd1.cd_marital_status = 'D'
     AND cd1.cd_marital_status = cd2.cd_marital_status
     AND cd1.cd_education_status = 'Advanced Degree'
     AND cd1.cd_education_status = cd2.cd_education_status
     AND ws.ws_sales_price BETWEEN 150.00 AND 200.00
     AND ((ca.ca_country = 'United States'
           AND ca.ca_state IN ('GA',
                         'IN',
                         'VA')
           AND ws.ws_net_profit BETWEEN 100 AND 200)
          OR (ca.ca_country = 'United States'
              AND ca.ca_state IN ('MT',
                            'NM',
                            'OR')
              AND ws.ws_net_profit BETWEEN 150 AND 300)
          OR (ca.ca_country = 'United States'
              AND ca.ca_state IN ('GA',
                            'IL',
                            'OH')
              AND ws.ws_net_profit BETWEEN 50 AND 250)))
SELECT substring(r_reason_desc, 1, 20),
       avg(ws_quantity),
       avg(wr_refunded_cash),
       avg(wr_fee)
FROM filtered_data
GROUP BY r_reason_desc
ORDER BY substring(r_reason_desc, 1, 20),
         avg(ws_quantity),
         avg(wr_refunded_cash),
         avg(wr_fee)
LIMIT 100;