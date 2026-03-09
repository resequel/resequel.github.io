WITH cd_sales AS
  (SELECT ws.ws_item_sk,
          ws.ws_order_number,
          ws.ws_quantity,
          wr.wr_refunded_cash,
          wr.wr_fee,
          wr.wr_refunded_cdemo_sk,
          wr.wr_returning_cdemo_sk,
          wr.wr_refunded_addr_sk,
          wr.wr_reason_sk,
          ws.ws_web_page_sk
   FROM web_sales ws
   JOIN web_returns wr ON ws.ws_item_sk = wr.ws_item_sk
   AND ws.ws_order_number = wr.ws_order_number
   JOIN customer_demographics cd1 ON wr.wr_refunded_cdemo_sk = cd1.cd_demo_sk
   JOIN customer_demographics cd2 ON wr.wr_returning_cdemo_sk = cd2.cd_demo_sk
   WHERE cd1.cd_marital_status = cd2.cd_marital_status
     AND cd1.cd_education_status = cd2.cd_education_status
     AND ((cd1.cd_marital_status = 'W'
           AND cd1.cd_education_status = '2 yr Degree'
           AND ws.ws_sales_price BETWEEN 100.00 AND 150.00)
          OR (cd1.cd_marital_status = 'S'
              AND cd1.cd_education_status = 'College'
              AND ws.ws_sales_price BETWEEN 50.00 AND 100.00)
          OR (cd1.cd_marital_status = 'D'
              AND cd1.cd_education_status = 'Advanced Degree'
              AND ws.ws_sales_price BETWEEN 150.00 AND 200.00))),
     ca_sales AS
  (SELECT ws.ws_item_sk,
          ws.ws_order_number
   FROM web_sales ws
   JOIN web_returns wr ON ws.ws_item_sk = wr.ws_item_sk
   AND ws.ws_order_number = wr.ws_order_number
   JOIN customer_address ca ON wr.wr_refunded_addr_sk = ca.ca_address_sk
   WHERE ((ca.ca_country = 'United States'
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
SELECT min(cs.ws_quantity),
       min(cs.wr_refunded_cash),
       min(cs.wr_fee),
       min(cs.ws_item_sk),
       min(cs.ws_order_number),
       min(cs.wr_refunded_cdemo_sk),
       min(cs.wr_returning_cdemo_sk)
FROM cd_sales cs
JOIN ca_sales ON cs.ws_item_sk = ca_sales.ws_item_sk
AND cs.ws_order_number = ca_sales.ws_order_number
JOIN web_sales ws ON cs.ws_item_sk = ws.ws_item_sk
AND cs.ws_order_number = ws.ws_order_number
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
JOIN web_page wp ON cs.ws_web_page_sk = wp.wp_web_page_sk
JOIN reason r ON cs.wr_reason_sk = r.r_reason_sk
WHERE d.d_year = 1998;