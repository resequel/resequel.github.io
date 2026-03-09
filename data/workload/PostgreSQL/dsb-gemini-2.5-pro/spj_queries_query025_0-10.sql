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
     AND d_moy BETWEEN 6 AND 6 + 2),
     ss_sr_joined AS
  (SELECT ss.*,
          sr.sr_net_loss,
          sr.sr_item_sk AS sr_item_sk_alias,
          sr.sr_ticket_number AS sr_ticket_number_alias
   FROM ss_filtered ss
   INNER JOIN sr_filtered sr ON ss.ss_customer_sk = sr.sr_customer_sk
   AND ss.ss_item_sk = sr.sr_item_sk
   AND ss.ss_ticket_number = sr.sr_ticket_number)
SELECT min(i.i_item_id),
       min(i.i_item_desc),
       min(s.s_store_id),
       min(s.s_store_name),
       min(ss_sr.ss_net_profit),
       min(ss_sr.sr_net_loss),
       min(cs.cs_net_profit),
       min(ss_sr.ss_item_sk),
       min(ss_sr.sr_ticket_number_alias),
       min(cs.cs_order_number)
FROM ss_sr_joined ss_sr
INNER JOIN cs_filtered cs ON ss_sr.ss_customer_sk = cs.cs_bill_customer_sk
AND ss_sr.sr_item_sk_alias = cs.cs_item_sk
INNER JOIN store s ON ss_sr.ss_store_sk = s.s_store_sk
INNER JOIN item i ON ss_sr.ss_item_sk = i.i_item_sk;