WITH filtered_demos AS
  (SELECT cd_demo_sk,
          cd_marital_status,
          cd_education_status
   FROM customer_demographics
   WHERE cd_marital_status IN ('W', 'S', 'D')
     AND cd_education_status IN ('2 yr Degree', 'College', 'Advanced Degree')),
     filtered_addr AS
  (SELECT ca_address_sk,
          ca_country,
          ca_state
   FROM customer_address
   WHERE ca_country IN ('United States', 'United States', 'United States'))
SELECT substring(r_reason_desc, 1, 20),
       avg(ws_quantity),
       avg(wr_refunded_cash),
       avg(wr_fee)
FROM web_sales
JOIN web_returns ON ws_item_sk = wr_item_sk
AND ws_order_number = wr_order_number
JOIN date_dim ON ws_sold_date_sk = d_date_sk
JOIN reason ON wr_reason_sk = r_reason_sk
JOIN filtered_demos cd1 ON wr_refunded_cdemo_sk = cd1.cd_demo_sk
JOIN filtered_demos cd2 ON wr_returning_cdemo_sk = cd2.cd_demo_sk
JOIN filtered_addr ca ON wr_refunded_addr_sk = ca.ca_address_sk
WHERE d_year = 1998
  AND cd1.cd_marital_status = cd2.cd_marital_status
  AND cd1.cd_education_status = cd2.cd_education_status
  AND ((cd1.cd_marital_status = 'W'
        AND cd1.cd_education_status = '2 yr Degree'
        AND ws_sales_price BETWEEN 100.00 AND 150.00)
       OR (cd1.cd_marital_status = 'S'
           AND cd1.cd_education_status = 'College'
           AND ws_sales_price BETWEEN 50.00 AND 100.00)
       OR (cd1.cd_marital_status = 'D'
           AND cd1.cd_education_status = 'Advanced Degree'
           AND ws_sales_price BETWEEN 150.00 AND 200.00))
  AND ((ca.ca_country = 'United States'
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
           AND ws_net_profit BETWEEN 50 AND 250))
GROUP BY r_reason_desc
ORDER BY substring(r_reason_desc, 1, 20),
         avg(ws_quantity),
         avg(wr_refunded_cash),
         avg(wr_fee)
LIMIT 100;