WITH date_keys AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_date BETWEEN '2000-10-01' AND cast('2000-10-01' AS date) + interval '60 day'),
     addr_keys AS
  (SELECT ca_address_sk
   FROM customer_address
   WHERE ca_state IN ('IA',
                   'IN',
                   'MT',
                   'NE',
                   'OK',
                   'TX')),
     site_keys AS
  (SELECT web_site_sk
   FROM web_site
   WHERE web_gmt_offset >= -7)
SELECT count(DISTINCT ws1.ws_order_number) AS "order count",
       sum(ws1.ws_ext_ship_cost) AS "total shipping cost",
       sum(ws1.ws_net_profit) AS "total net profit"
FROM web_sales ws1
WHERE ws1.ws_ship_date_sk IN
    (SELECT d_date_sk
     FROM date_keys)
  AND ws1.ws_ship_addr_sk IN
    (SELECT ca_address_sk
     FROM addr_keys)
  AND ws1.ws_web_site_sk IN
    (SELECT web_site_sk
     FROM site_keys)
  AND ws1.ws_list_price BETWEEN 141 AND 170
  AND EXISTS
    (SELECT 1
     FROM web_sales ws2
     WHERE ws1.ws_order_number = ws2.ws_order_number
       AND ws1.ws_warehouse_sk <> ws2.ws_warehouse_sk)
  AND NOT EXISTS
    (SELECT 1
     FROM web_returns wr1
     WHERE ws1.ws_order_number = wr1.wr_order_number
       AND wr1.wr_reason_sk IN (7, 10, 12, 29, 45))
ORDER BY "order count"
LIMIT 100;