WITH avg_discount_per_item AS
  (SELECT ws.ws_item_sk,
          (1.3 * avg(ws.ws_ext_discount_amt)) AS avg_discount_threshold
   FROM web_sales ws
   JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
   WHERE d.d_date BETWEEN '2002-02-11' AND cast('2002-02-11' AS date) + interval '90 day'
     AND ws.ws_wholesale_cost BETWEEN 68 AND 88
     AND ws.ws_list_price > 0
     AND (ws.ws_sales_price / ws.ws_list_price) BETWEEN 85 * 0.01 AND 100 * 0.01
   GROUP BY ws.ws_item_sk)
SELECT sum(ws_ext_discount_amt) AS "Excess Discount Amount"
FROM
  (SELECT ws.ws_ext_discount_amt
   FROM web_sales ws
   JOIN item i ON ws.ws_item_sk = i.i_item_sk
   JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN avg_discount_per_item ad ON ws.ws_item_sk = ad.ws_item_sk
   WHERE i.i_manufact_id BETWEEN 394 AND 593
     AND d.d_date BETWEEN '2002-02-11' AND cast('2002-02-11' AS date) + interval '90 day'
     AND ws.ws_wholesale_cost BETWEEN 68 AND 88
     AND ws.ws_ext_discount_amt > ad.avg_discount_threshold
   UNION ALL SELECT ws.ws_ext_discount_amt
   FROM web_sales ws
   JOIN item i ON ws.ws_item_sk = i.i_item_sk
   JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN avg_discount_per_item ad ON ws.ws_item_sk = ad.ws_item_sk
   WHERE i.i_category IN ('Books',
                         'Home',
                         'Sports')
     AND NOT (i.i_manufact_id BETWEEN 394 AND 593)
     AND d.d_date BETWEEN '2002-02-11' AND cast('2002-02-11' AS date) + interval '90 day'
     AND ws.ws_wholesale_cost BETWEEN 68 AND 88
     AND ws.ws_ext_discount_amt > ad.avg_discount_threshold) AS TEMP
ORDER BY "Excess Discount Amount"
LIMIT 100;