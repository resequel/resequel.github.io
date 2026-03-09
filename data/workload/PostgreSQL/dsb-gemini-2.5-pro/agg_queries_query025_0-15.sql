WITH ss_filtered AS
  (SELECT ss_item_sk,
          ss_customer_sk,
          ss_ticket_number,
          ss_store_sk,
          ss_net_profit
   FROM store_sales
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   WHERE d_moy = 8
     AND d_year = 2001),
     sr_filtered AS
  (SELECT sr_item_sk,
          sr_customer_sk,
          sr_ticket_number,
          sr_net_loss
   FROM store_returns
   JOIN date_dim ON sr_returned_date_sk = d_date_sk
   WHERE d_moy BETWEEN 8 AND 8 + 2
     AND d_year = 2001),
     cs_filtered AS
  (SELECT cs_item_sk,
          cs_bill_customer_sk,
          cs_net_profit
   FROM catalog_sales
   JOIN date_dim ON cs_sold_date_sk = d_date_sk
   WHERE d_moy BETWEEN 8 AND 8 + 2
     AND d_year = 2001)
SELECT i.i_item_id,
       i.i_item_desc,
       s.s_store_id,
       s.s_store_name,
       sum(ss.ss_net_profit) AS store_sales_profit,
       sum(sr.sr_net_loss) AS store_returns_loss,
       sum(cs.cs_net_profit) AS catalog_sales_profit
FROM ss_filtered ss
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN sr_filtered sr ON ss.ss_customer_sk = sr.sr_customer_sk
AND ss.ss_item_sk = sr.sr_item_sk
AND ss.ss_ticket_number = sr.sr_ticket_number
JOIN cs_filtered cs ON sr.sr_customer_sk = cs.cs_bill_customer_sk
AND sr.sr_item_sk = cs.cs_item_sk
GROUP BY i.i_item_id,
         i.i_item_desc,
         s.s_store_id,
         s.s_store_name
ORDER BY i.i_item_id,
         i.i_item_desc,
         s.s_store_id,
         s.s_store_name
LIMIT 100;