
SELECT ss_items.i_item_id,
       ss_items.i_item_desc,
       ss_items.s_store_id,
       ss_items.s_store_name,
       sum(ss_items.store_sales_profit) AS store_sales_profit,
       sum(sr_items.store_returns_loss) AS store_returns_loss,
       sum(cs_items.catalog_sales_profit) AS catalog_sales_profit
FROM
  (SELECT i.i_item_id,
          i.i_item_desc,
          s.s_store_id,
          s.s_store_name,
          ss.ss_customer_sk,
          ss.ss_item_sk,
          ss.ss_ticket_number,
          sum(ss.ss_net_profit) AS store_sales_profit
   FROM store_sales ss
   JOIN date_dim d1 ON ss.ss_sold_date_sk = d1.d_date_sk
   JOIN store s ON ss.ss_store_sk = s.s_store_sk
   JOIN item i ON ss.ss_item_sk = i.i_item_sk
   WHERE d1.d_moy = 8
     AND d1.d_year = 2001
   GROUP BY i.i_item_id,
            i.i_item_desc,
            s.s_store_id,
            s.s_store_name,
            ss.ss_customer_sk,
            ss.ss_item_sk,
            ss.ss_ticket_number) AS ss_items
JOIN
  (SELECT sr.sr_customer_sk,
          sr.sr_item_sk,
          sr.sr_ticket_number,
          sum(sr.sr_net_loss) AS store_returns_loss
   FROM store_returns sr
   JOIN date_dim d2 ON sr.sr_returned_date_sk = d2.d_date_sk
   WHERE d2.d_year = 2001
     AND d2.d_moy BETWEEN 8 AND 8 + 2
   GROUP BY sr.sr_customer_sk,
            sr.sr_item_sk,
            sr.sr_ticket_number) AS sr_items ON ss_items.ss_customer_sk = sr_items.sr_customer_sk
AND ss_items.ss_item_sk = sr_items.sr_item_sk
AND ss_items.ss_ticket_number = sr_items.sr_ticket_number
JOIN
  (SELECT cs.cs_bill_customer_sk,
          cs.cs_item_sk,
          sum(cs.cs_net_profit) AS catalog_sales_profit
   FROM catalog_sales cs
   JOIN date_dim d3 ON cs.cs_sold_date_sk = d3.d_date_sk
   WHERE d3.d_year = 2001
     AND d3.d_moy BETWEEN 8 AND 8 + 2
   GROUP BY cs.cs_bill_customer_sk,
            cs.cs_item_sk) AS cs_items ON sr_items.sr_customer_sk = cs_items.cs_bill_customer_sk
AND sr_items.sr_item_sk = cs_items.cs_item_sk
GROUP BY ss_items.i_item_id,
         ss_items.i_item_desc,
         ss_items.s_store_id,
         ss_items.s_store_name
ORDER BY i_item_id,
         i_item_desc,
         s_store_id,
         s_store_name
LIMIT 100;