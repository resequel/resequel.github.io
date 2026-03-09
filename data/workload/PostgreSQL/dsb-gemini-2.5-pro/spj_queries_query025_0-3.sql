WITH ss_filtered AS
  (SELECT ss_item_sk,
          ss_customer_sk,
          ss_ticket_number,
          ss_store_sk,
          ss_net_profit
   FROM store_sales,
        date_dim
   WHERE ss_sold_date_sk = d_date_sk
     AND d_moy = 6
     AND d_year = 2000),
     sr_filtered AS
  (SELECT sr_item_sk,
          sr_customer_sk,
          sr_ticket_number,
          sr_net_loss
   FROM store_returns,
        date_dim
   WHERE sr_returned_date_sk = d_date_sk
     AND d_year = 2000
     AND d_moy BETWEEN 6 AND 6 + 2),
     cs_filtered AS
  (SELECT cs_item_sk,
          cs_bill_customer_sk,
          cs_order_number,
          cs_net_profit
   FROM catalog_sales,
        date_dim
   WHERE cs_sold_date_sk = d_date_sk
     AND d_year = 2000
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
FROM ss_filtered ss
INNER JOIN item i ON ss.ss_item_sk = i.i_item_sk
INNER JOIN store s ON ss.ss_store_sk = s.s_store_sk
INNER JOIN sr_filtered sr ON ss.ss_customer_sk = sr.sr_customer_sk
AND ss.ss_item_sk = sr.sr_item_sk
AND ss.ss_ticket_number = sr.sr_ticket_number
INNER JOIN cs_filtered cs ON sr.sr_customer_sk = cs.cs_bill_customer_sk
AND sr.sr_item_sk = cs.cs_item_sk;