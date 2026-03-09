
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
INNER JOIN store_returns sr ON ss.ss_customer_sk = sr.sr_customer_sk
AND ss.ss_item_sk = sr.sr_item_sk
AND ss.ss_ticket_number = sr.sr_ticket_number
INNER JOIN catalog_sales cs ON sr.sr_customer_sk = cs.cs_bill_customer_sk
AND sr.sr_item_sk = cs.cs_item_sk
INNER JOIN store s ON ss.ss_store_sk = s.s_store_sk
INNER JOIN item i ON ss.ss_item_sk = i.i_item_sk
WHERE ss.ss_sold_date_sk IN
    (SELECT d_date_sk
     FROM date_dim
     WHERE d_moy = 6
       AND d_year = 2000)
  AND sr.sr_returned_date_sk IN
    (SELECT d_date_sk
     FROM date_dim
     WHERE d_year = 2000
       AND d_moy BETWEEN 6 AND 6 + 2)
  AND cs.cs_sold_date_sk IN
    (SELECT d_date_sk
     FROM date_dim
     WHERE d_year = 2000
       AND d_moy BETWEEN 6 AND 6 + 2);