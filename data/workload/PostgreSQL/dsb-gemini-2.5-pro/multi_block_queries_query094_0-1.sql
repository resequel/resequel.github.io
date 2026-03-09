WITH sales_filtered AS
  (SELECT ws.ws_order_number,
          ws.ws_ext_ship_cost,
          ws.ws_net_profit,
          ws.ws_warehouse_sk
   FROM web_sales ws
   JOIN date_dim d ON ws.ws_ship_date_sk = d.d_date_sk
   AND d.d_date BETWEEN '2000-10-01' AND cast('2000-10-01' AS date) + interval '60 day'
   JOIN customer_address ca ON ws.ws_ship_addr_sk = ca.ca_address_sk
   AND ca.ca_state IN ('IA',
                   'IN',
                   'MT',
                   'NE',
                   'OK',
                   'TX')
   JOIN web_site w ON ws.ws_web_site_sk = w.web_site_sk
   AND w.web_gmt_offset >= -7
   WHERE ws.ws_list_price BETWEEN 141 AND 170),
     sales_with_wh_count AS
  (SELECT *,
          count(DISTINCT ws_warehouse_sk) OVER (PARTITION BY ws_order_number) AS wh_count
   FROM sales_filtered)
SELECT count(DISTINCT ws_order_number) AS "order count",
       sum(ws_ext_ship_cost) AS "total shipping cost",
       sum(ws_net_profit) AS "total net profit"
FROM sales_with_wh_count
WHERE wh_count > 1
  AND NOT EXISTS
    (SELECT 1
     FROM web_returns wr
     WHERE sales_with_wh_count.ws_order_number = wr.wr_order_number
       AND wr.wr_reason_sk IN (7, 10, 12, 29, 45))
ORDER BY "order count"
LIMIT 100;