WITH all_joins AS
  (SELECT ws.ws_quantity,
          ws.ws_sales_price,
          ws.ws_net_profit,
          wr.wr_refunded_cash,
          wr.wr_fee,
          r.r_reason_desc,
          cd1.cd_marital_status AS cd1_ms,
          cd1.cd_education_status AS cd1_es,
          cd2.cd_marital_status AS cd2_ms,
          cd2.cd_education_status AS cd2_es,
          ca.ca_country,
          ca.ca_state
   FROM web_sales ws
   JOIN web_returns wr ON ws.ws_item_sk = wr.wr_item_sk
   AND ws.ws_order_number = wr.wr_order_number
   JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN customer_demographics cd1 ON wr.wr_refunded_cdemo_sk = cd1.cd_demo_sk
   JOIN customer_demographics cd2 ON wr.wr_returning_cdemo_sk = cd2.cd_demo_sk
   JOIN customer_address ca ON wr.wr_refunded_addr_sk = ca.ca_address_sk
   JOIN reason r ON wr.wr_reason_sk = r.r_reason_sk
   WHERE d.d_year = 1998)
SELECT substring(r_reason_desc, 1, 20),
       avg(ws_quantity),
       avg(wr_refunded_cash),
       avg(wr_fee)
FROM all_joins
WHERE ((cd1_ms = 'W'
        AND cd1_ms = cd2_ms
        AND cd1_es = '2 yr Degree'
        AND cd1_es = cd2_es
        AND ws_sales_price BETWEEN 100.00 AND 150.00)
       OR (cd1_ms = 'S'
           AND cd1_ms = cd2_ms
           AND cd1_es = 'College'
           AND cd1_es = cd2_es
           AND ws_sales_price BETWEEN 50.00 AND 100.00)
       OR (cd1_ms = 'D'
           AND cd1_ms = cd2_ms
           AND cd1_es = 'Advanced Degree'
           AND cd1_es = cd2_es
           AND ws_sales_price BETWEEN 150.00 AND 200.00))
  AND ((ca_country = 'United States'
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
         avg(ws_quantity),
         avg(wr_refunded_cash),
         avg(wr_fee)
LIMIT 100;