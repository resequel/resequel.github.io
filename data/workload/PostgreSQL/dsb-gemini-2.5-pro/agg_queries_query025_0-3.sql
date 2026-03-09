WITH ss_items AS
  (SELECT i.i_item_id,
          i.i_item_desc,
          s.s_store_id,
          s.s_store_name,
          ss.ss_customer_sk,
          ss.ss_item_sk,
          ss.ss_ticket_number,
          sum(ss.ss_net_profit) AS store_sales_profit
   FROM store_sales ss,
        store s,
        item i
   WHERE ss.ss_store_sk = s.s_store_sk
     AND ss.ss_item_sk = i.i_item_sk
     AND ss.ss_sold_date_sk IN
       (SELECT d_date_sk
        FROM date_dim
        WHERE d_moy = 8
          AND d_year = 2001)
   GROUP BY i.i_item_id,
            i.i_item_desc,
            s.s_store_id,
            s.s_store_name,
            ss.ss_customer_sk,
            ss.ss_item_sk,
            ss.ss_ticket_number),
     sr_items AS
  (SELECT sr.sr_customer_sk,
          sr.sr_item_sk,
          sr.sr_ticket_number,
          sum(sr.sr_net_loss) AS store_returns_loss
   FROM store_returns sr
   WHERE sr.sr_returned_date_sk IN
       (SELECT d_date_sk
        FROM date_dim
        WHERE d_year = 2001
          AND d_moy BETWEEN 8 AND 8 + 2)
   GROUP BY sr.sr_customer_sk,
            sr.sr_item_sk,
            sr.sr_ticket_number),
     cs_items AS
  (SELECT cs.cs_bill_customer_sk,
          cs.cs_item_sk,
          sum(cs.cs_net_profit) AS catalog_sales_profit
   FROM catalog_sales cs
   WHERE cs.cs_sold_date_sk IN
       (SELECT d_date_sk
        FROM date_dim
        WHERE d_year = 2001
          AND d_moy BETWEEN 8 AND 8 + 2)
   GROUP BY cs.cs_bill_customer_sk,
            cs.cs_item_sk)
SELECT ss_items.i_item_id,
       ss_items.i_item_desc,
       ss_items.s_store_id,
       ss_items.s_store_name,
       sum(ss_items.store_sales_profit),
       sum(sr_items.store_returns_loss),
       sum(cs_items.catalog_sales_profit)
FROM ss_items
JOIN sr_items ON ss_items.ss_customer_sk = sr_items.sr_customer_sk
AND ss_items.ss_item_sk = sr_items.sr_item_sk
AND ss_items.ss_ticket_number = sr_items.sr_ticket_number
JOIN cs_items ON sr_items.sr_customer_sk = cs_items.cs_bill_customer_sk
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