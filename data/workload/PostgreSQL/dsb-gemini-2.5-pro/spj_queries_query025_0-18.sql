
SELECT min(i.i_item_id),
       min(i.i_item_desc),
       min(s.s_store_id),
       min(s.s_store_name),
       min(ss_net_profit),
       min(sr_net_loss),
       min(cs_net_profit),
       min(ss_item_sk),
       min(sr_ticket_number),
       min(cs_order_number)
FROM store_sales
INNER JOIN date_dim d1 ON ss_sold_date_sk = d1.d_date_sk
INNER JOIN item ON ss_item_sk = i_item_sk
INNER JOIN store ON ss_store_sk = s_store_sk
INNER JOIN store_returns ON ss_customer_sk = sr_customer_sk
AND ss_item_sk = sr_item_sk
AND ss_ticket_number = sr_ticket_number
INNER JOIN date_dim d2 ON sr_returned_date_sk = d2.d_date_sk
INNER JOIN catalog_sales ON sr_customer_sk = cs_bill_customer_sk
AND sr_item_sk = cs_item_sk
INNER JOIN date_dim d3 ON cs_sold_date_sk = d3.d_date_sk
WHERE d1.d_moy = 6
  AND d1.d_year = 2000
  AND d2.d_moy BETWEEN 6 AND 6 + 2
  AND d2.d_year = 2000
  AND d3.d_moy BETWEEN 6 AND 6 + 2
  AND d3.d_year = 2000;