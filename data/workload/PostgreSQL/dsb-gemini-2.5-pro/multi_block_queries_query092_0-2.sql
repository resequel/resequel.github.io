
SELECT sum(ws_ext_discount_amt) AS "Excess Discount Amount"
FROM web_sales
INNER JOIN item ON i_item_sk = ws_item_sk
INNER JOIN date_dim ON d_date_sk = ws_sold_date_sk
WHERE (i_manufact_id BETWEEN 394 AND 593
       OR i_category IN ('Books',
                         'Home',
                         'Sports'))
  AND d_date BETWEEN '2002-02-11' AND cast('2002-02-11' AS date) + interval '90 day'
  AND ws_wholesale_cost BETWEEN 68 AND 88
  AND ws_ext_discount_amt >
    (SELECT 1.3 * avg(ws_ext_discount_amt)
     FROM web_sales,
          date_dim
     WHERE ws_item_sk = i_item_sk
       AND d_date BETWEEN '2002-02-11' AND cast('2002-02-11' AS date) + interval '90 day'
       AND d_date_sk = ws_sold_date_sk
       AND ws_wholesale_cost BETWEEN 68 AND 88
       AND ws_sales_price / ws_list_price BETWEEN 85 * 0.01 AND 100 * 0.01)
ORDER BY sum(ws_ext_discount_amt)
LIMIT 100;