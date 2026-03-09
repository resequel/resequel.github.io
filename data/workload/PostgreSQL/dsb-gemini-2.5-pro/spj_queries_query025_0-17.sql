WITH d1_filtered AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_moy = 6
     AND d_year = 2000),
     d2_filtered AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 2000
     AND d_moy BETWEEN 6 AND 6 + 2),
     d3_filtered AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 2000
     AND d_moy BETWEEN 6 AND 6 + 2),
     ss_filtered AS
  (SELECT ss_customer_sk,
          ss_item_sk,
          ss_ticket_number,
          ss_net_profit,
          ss_store_sk
   FROM store_sales
   JOIN d1_filtered ON ss_sold_date_sk = d1_filtered.d_date_sk),
     sr_filtered AS
  (SELECT sr_customer_sk,
          sr_item_sk,
          sr_ticket_number,
          sr_net_loss
   FROM store_returns
   JOIN d2_filtered ON sr_returned_date_sk = d2_filtered.d_date_sk),
     cs_filtered AS
  (SELECT cs_bill_customer_sk,
          cs_item_sk,
          cs_net_profit,
          cs_order_number
   FROM catalog_sales
   JOIN d3_filtered ON cs_sold_date_sk = d3_filtered.d_date_sk)
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
FROM ss_filtered ss
JOIN sr_filtered sr ON ss.ss_customer_sk = sr.sr_customer_sk
AND ss.ss_item_sk = sr.sr_item_sk
AND ss.ss_ticket_number = sr.sr_ticket_number
JOIN cs_filtered cs ON sr.sr_customer_sk = cs.cs_bill_customer_sk
AND sr.sr_item_sk = cs.cs_item_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk;