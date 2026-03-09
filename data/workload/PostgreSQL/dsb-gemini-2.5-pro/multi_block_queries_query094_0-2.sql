WITH valid_orders AS
  (SELECT ws1.ws_order_number
   FROM web_sales ws1
   JOIN date_dim ON ws1.ws_ship_date_sk = d_date_sk
   AND d_date BETWEEN '2000-10-01' AND cast('2000-10-01' AS date) + interval '60 day'
   JOIN customer_address ON ws1.ws_ship_addr_sk = ca_address_sk
   AND ca_state IN ('IA',
                   'IN',
                   'MT',
                   'NE',
                   'OK',
                   'TX')
   JOIN web_site ON ws1.ws_web_site_sk = web_site_sk
   AND web_gmt_offset >= -7
   WHERE ws1.ws_list_price BETWEEN 141 AND 170
     AND NOT EXISTS
       (SELECT 1
        FROM web_returns wr1
        WHERE ws1.ws_order_number = wr1.wr_order_number
          AND wr1.wr_reason_sk IN (7, 10, 12, 29, 45))
   GROUP BY ws1.ws_order_number
   HAVING count(DISTINCT ws1.ws_warehouse_sk) > 1)
SELECT count(DISTINCT ws.ws_order_number) AS "order count",
       sum(ws.ws_ext_ship_cost) AS "total shipping cost",
       sum(ws.ws_net_profit) AS "total net profit"
FROM web_sales ws
JOIN valid_orders vo ON ws.ws_order_number = vo.ws_order_number
ORDER BY "order count"
LIMIT 100;