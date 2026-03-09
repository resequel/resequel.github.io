WITH d1_filtered AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_moy = 8
     AND d_year = 2001),
     d2_filtered AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_moy BETWEEN 8 AND 8 + 2
     AND d_year = 2001),
     d3_filtered AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_moy BETWEEN 8 AND 8 + 2
     AND d_year = 2001)
SELECT i.i_item_id,
       i.i_item_desc,
       s.s_store_id,
       s.s_store_name,
       sum(ss.ss_net_profit) AS store_sales_profit,
       sum(sr.sr_net_loss) AS store_returns_loss,
       sum(cs.cs_net_profit) AS catalog_sales_profit
FROM store_sales ss
JOIN d1_filtered d1 ON ss.ss_sold_date_sk = d1.d_date_sk
JOIN store_returns sr ON ss.ss_customer_sk = sr.sr_customer_sk
AND ss.ss_item_sk = sr.sr_item_sk
AND ss.ss_ticket_number = sr.sr_ticket_number
JOIN d2_filtered d2 ON sr.sr_returned_date_sk = d2.d_date_sk
JOIN catalog_sales cs ON sr.sr_customer_sk = cs.cs_bill_customer_sk
AND sr.sr_item_sk = cs.cs_item_sk
JOIN d3_filtered d3 ON cs.cs_sold_date_sk = d3.d_date_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
GROUP BY i.i_item_id,
         i.i_item_desc,
         s.s_store_id,
         s.s_store_name
ORDER BY i.i_item_id,
         i.i_item_desc,
         s.s_store_id,
         s.s_store_name
LIMIT 100;