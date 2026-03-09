
SELECT min(ws.ws_quantity),
       min(wr.wr_refunded_cash),
       min(wr.wr_fee),
       min(ws.ws_item_sk),
       min(wr.wr_order_number),
       min(cd1.cd_demo_sk),
       min(cd2.cd_demo_sk)
FROM web_sales ws
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
JOIN web_returns wr ON ws.ws_item_sk = wr.ws_item_sk
AND ws.ws_order_number = wr.ws_order_number
JOIN customer_demographics cd1 ON wr.wr_refunded_cdemo_sk = cd1.cd_demo_sk
JOIN customer_demographics cd2 ON wr.wr_returning_cdemo_sk = cd2.cd_demo_sk
JOIN customer_address ca ON wr.wr_refunded_addr_sk = ca.ca_address_sk
JOIN (
      VALUES ('W', '2 yr Degree', 100.00, 150.00), ('S', 'College', 50.00, 100.00), ('D', 'Advanced Degree', 150.00, 200.00)) AS demo_filters(ms, es, p_min, p_max) ON cd1.cd_marital_status = demo_filters.ms
AND cd1.cd_education_status = demo_filters.es
AND ws.ws_sales_price BETWEEN demo_filters.p_min AND demo_filters.p_max
WHERE d.d_year = 1998
  AND cd1.cd_marital_status = cd2.cd_marital_status
  AND cd1.cd_education_status = cd2.cd_education_status
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