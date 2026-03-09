WITH date_selection AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 1998),
     demo_selection AS
  (SELECT cd_demo_sk,
          cd_marital_status,
          cd_education_status
   FROM customer_demographics
   WHERE (cd_marital_status = 'W'
          AND cd_education_status = '2 yr Degree')
     OR (cd_marital_status = 'S'
         AND cd_education_status = 'College')
     OR (cd_marital_status = 'D'
         AND cd_education_status = 'Advanced Degree')),
     addr_selection AS
  (SELECT ca_address_sk,
          ca_country,
          ca_state
   FROM customer_address
   WHERE (ca_country = 'United States'
          AND ca_state IN ('GA',
                         'IN',
                         'VA'))
     OR (ca_country = 'United States'
         AND ca_state IN ('MT',
                            'NM',
                            'OR'))
     OR (ca_country = 'United States'
         AND ca_state IN ('GA',
                            'IL',
                            'OH')))
SELECT substring(r.r_reason_desc, 1, 20),
       avg(ws.ws_quantity),
       avg(wr.wr_refunded_cash),
       avg(wr.wr_fee)
FROM web_sales ws
JOIN date_selection d ON ws.ws_sold_date_sk = d.d_date_sk
JOIN web_returns wr ON ws.ws_item_sk = wr.wr_item_sk
AND ws.ws_order_number = wr.wr_order_number
JOIN demo_selection cd1 ON wr.wr_refunded_cdemo_sk = cd1.cd_demo_sk
JOIN demo_selection cd2 ON wr.wr_returning_cdemo_sk = cd2.cd_demo_sk
JOIN addr_selection ca ON wr.wr_refunded_addr_sk = ca.ca_address_sk
JOIN reason r ON wr.wr_reason_sk = r.r_reason_sk
WHERE cd1.cd_marital_status = cd2.cd_marital_status
  AND cd1.cd_education_status = cd2.cd_education_status
  AND ((cd1.cd_marital_status = 'W'
        AND ws.ws_sales_price BETWEEN 100.00 AND 150.00)
       OR (cd1.cd_marital_status = 'S'
           AND ws.ws_sales_price BETWEEN 50.00 AND 100.00)
       OR (cd1.cd_marital_status = 'D'
           AND ws.ws_sales_price BETWEEN 150.00 AND 200.00))
  AND ((ca.ca_country = 'United States'
        AND ws.ws_net_profit BETWEEN 100 AND 200)
       OR (ca.ca_country = 'United States'
           AND ws.ws_net_profit BETWEEN 150 AND 300)
       OR (ca.ca_country = 'United States'
           AND ws.ws_net_profit BETWEEN 50 AND 250))
GROUP BY r.r_reason_desc
ORDER BY substring(r.r_reason_desc, 1, 20),
         avg(ws.ws_quantity),
         avg(wr.wr_refunded_cash),
         avg(wr.wr_fee)
LIMIT 100;