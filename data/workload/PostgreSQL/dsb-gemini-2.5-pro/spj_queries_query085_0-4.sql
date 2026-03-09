WITH filtered_sales AS
  (SELECT ws_quantity,
          ws_item_sk,
          ws_order_number,
          ws_sales_price,
          ws_net_profit,
          ws_web_page_sk
   FROM web_sales
   JOIN date_dim ON ws_sold_date_sk = d_date_sk
   WHERE d_year = 1998)
SELECT min(ws_quantity),
       min(wr_refunded_cash),
       min(wr_fee),
       min(ws_item_sk),
       min(wr_order_number),
       min(cd1.cd_demo_sk),
       min(cd2.cd_demo_sk)
FROM filtered_sales ws
JOIN web_returns wr ON ws.ws_item_sk = wr.ws_item_sk
AND ws.ws_order_number = wr.ws_order_number
JOIN web_page wp ON ws.ws_web_page_sk = wp.wp_web_page_sk
JOIN customer_demographics cd1 ON wr.wr_refunded_cdemo_sk = cd1.cd_demo_sk
JOIN customer_demographics cd2 ON wr.wr_returning_cdemo_sk = cd2.cd_demo_sk
JOIN customer_address ca ON wr.wr_refunded_addr_sk = ca.ca_address_sk
JOIN reason r ON r.r_reason_sk = wr.wr_reason_sk
WHERE ((cd1.cd_marital_status = 'W'
        AND cd1.cd_marital_status = cd2.cd_marital_status
        AND cd1.cd_education_status = '2 yr Degree'
        AND cd1.cd_education_status = cd2.cd_education_status
        AND ws.ws_sales_price BETWEEN 100.00 AND 150.00)
       OR (cd1.cd_marital_status = 'S'
           AND cd1.cd_marital_status = cd2.cd_marital_status
           AND cd1.cd_education_status = 'College'
           AND cd1.cd_education_status = cd2.cd_education_status
           AND ws.ws_sales_price BETWEEN 50.00 AND 100.00)
       OR (cd1.cd_marital_status = 'D'
           AND cd1.cd_marital_status = cd2.cd_marital_status
           AND cd1.cd_education_status = 'Advanced Degree'
           AND cd1.cd_education_status = cd2.cd_education_status
           AND ws.ws_sales_price BETWEEN 150.00 AND 200.00))
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
           AND ws.ws_net_profit BETWEEN 50 AND 250));