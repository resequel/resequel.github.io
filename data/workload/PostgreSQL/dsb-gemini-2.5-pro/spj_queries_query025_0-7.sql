
SELECT min(i.i_item_id),
       min(i.i_item_desc),
       min(s.s_store_id),
       min(s.s_store_name),
       min(ss.ss_net_profit),
       min(sr.sr_net_loss),
       min(cs.cs_net_profit),
       min(ss.ss_item_sk),
       min(sr.sr_ticket_number),
       min(cs.cs_order_number)
FROM store_sales ss
JOIN date_dim d1 ON d1.d_date_sk = ss.ss_sold_date_sk
JOIN item i ON i.i_item_sk = ss.ss_item_sk
JOIN store s ON s.s_store_sk = ss.ss_store_sk
JOIN store_returns sr ON ss.ss_customer_sk = sr.sr_customer_sk
AND ss.ss_item_sk = sr.sr_item_sk
AND ss.ss_ticket_number = sr.sr_ticket_number
JOIN date_dim d2 ON sr.sr_returned_date_sk = d2.d_date_sk
JOIN catalog_sales cs ON sr.sr_customer_sk = cs.cs_bill_customer_sk
AND sr.sr_item_sk = cs.cs_item_sk
JOIN date_dim d3 ON cs.cs_sold_date_sk = d3.d_date_sk
WHERE d1.d_moy = 6
  AND d1.d_year = 2000
  AND d2.d_moy BETWEEN 6 AND 6 + 2
  AND d2.d_year = 2000
  AND d3.d_moy BETWEEN 6 AND 6 + 2
  AND d3.d_year = 2000;