WITH d1_dates AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_moy = 6
     AND d_year = 2000),
     d2_dates AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 2000
     AND d_moy BETWEEN 6 AND 6 + 2),
     d3_dates AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 2000
     AND d_moy BETWEEN 6 AND 6 + 2)
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
INNER JOIN d1_dates ON ss.ss_sold_date_sk = d1_dates.d_date_sk
INNER JOIN store_returns sr ON ss.ss_customer_sk = sr.sr_customer_sk
AND ss.ss_item_sk = sr.sr_item_sk
AND ss.ss_ticket_number = sr.sr_ticket_number
INNER JOIN d2_dates ON sr.sr_returned_date_sk = d2_dates.d_date_sk
INNER JOIN catalog_sales cs ON sr.sr_customer_sk = cs.cs_bill_customer_sk
AND sr.sr_item_sk = cs.cs_item_sk
INNER JOIN d3_dates ON cs.cs_sold_date_sk = d3_dates.d_date_sk
INNER JOIN store s ON ss.ss_store_sk = s.s_store_sk
INNER JOIN item i ON ss.ss_item_sk = i.i_item_sk;