WITH demo_conditions AS
  (SELECT v.*
   FROM (
         VALUES ('W', '2 yr Degree', 100.00, 150.00), ('S', 'College', 50.00, 100.00), ('D', 'Advanced Degree', 150.00, 200.00)) AS v(marital_status, education_status, price_min, price_max)),
     addr_conditions AS
  (SELECT v.*
   FROM (
         VALUES ('United States',
                    ('GA',
                         'IN',
                         'VA'), 100, 200), ('United States',
                                                ('MT',
                            'NM',
                            'OR'), 150, 300), ('United States',
                                                                            ('GA',
                            'IL',
                            'OH'), 50, 250)) AS v(country, states, profit_min, profit_max))
SELECT substring(r_reason_desc, 1, 20),
       avg(ws_quantity),
       avg(wr_refunded_cash),
       avg(wr_fee)
FROM web_sales
JOIN web_returns ON ws_item_sk = wr_item_sk
AND ws_order_number = wr_order_number
JOIN date_dim ON ws_sold_date_sk = d_date_sk
JOIN reason ON wr_reason_sk = r_reason_sk
JOIN customer_demographics cd1 ON wr_refunded_cdemo_sk = cd1.cd_demo_sk
JOIN customer_demographics cd2 ON wr_returning_cdemo_sk = cd2.cd_demo_sk
JOIN customer_address ON wr_refunded_addr_sk = ca_address_sk
JOIN demo_conditions dc ON cd1.cd_marital_status = dc.marital_status
AND cd1.cd_education_status = dc.education_status
AND ws_sales_price BETWEEN dc.price_min AND dc.price_max
JOIN addr_conditions ac ON ca.ca_country = ac.country
AND ca.ca_state IN ac.states
AND ws_net_profit BETWEEN ac.profit_min AND ac.profit_max
WHERE d_year = 1998
  AND cd1.cd_marital_status = cd2.cd_marital_status
  AND cd1.cd_education_status = cd2.cd_education_status
GROUP BY r_reason_desc
ORDER BY substring(r_reason_desc, 1, 20),
         avg(ws_quantity),
         avg(wr_refunded_cash),
         avg(wr_fee)
LIMIT 100;