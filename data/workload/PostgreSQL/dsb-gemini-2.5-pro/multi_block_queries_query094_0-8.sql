WITH candidate_sales AS
  (SELECT ws.ws_order_number,
          ws.ws_warehouse_sk,
          ws.ws_ext_ship_cost,
          ws.ws_net_profit
   FROM web_sales ws
   JOIN date_dim ON ws.ws_ship_date_sk = d_date_sk
   AND d_date BETWEEN '2000-10-01' AND cast('2000-10-01' AS date) + interval '60 day'
   JOIN customer_address ON ws.ws_ship_addr_sk = ca_address_sk
   AND ca_state IN ('IA',
                   'IN',
                   'MT',
                   'NE',
                   'OK',
                   'TX')
   JOIN web_site ON ws.ws_web_site_sk = web_site_sk
   AND web_gmt_offset >= -7
   WHERE ws.ws_list_price BETWEEN 141 AND 170),
     order_aggregates AS
  (SELECT ws_order_number,
          sum(ws_ext_ship_cost) AS total_ship_cost,
          sum(ws_net_profit) AS total_net_profit
   FROM candidate_sales
   GROUP BY ws_order_number
   HAVING count(DISTINCT ws_warehouse_sk) > 1)
SELECT count(oa.ws_order_number) AS "order count",
       sum(oa.total_ship_cost) AS "total shipping cost",
       sum(oa.total_net_profit) AS "total net profit"
FROM order_aggregates oa
WHERE oa.ws_order_number IN
    (SELECT ws_order_number
     FROM order_aggregates
     EXCEPT SELECT wr_order_number
     FROM web_returns
     WHERE wr_reason_sk IN (7, 10, 12, 29, 45))
ORDER BY "order count"
LIMIT 100;