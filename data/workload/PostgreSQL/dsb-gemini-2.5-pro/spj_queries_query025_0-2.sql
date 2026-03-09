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
          ss_ticket_number
   FROM store_sales
   WHERE ss_sold_date_sk IN
       (SELECT d_date_sk
        FROM d1_filtered)),
     sr_filtered AS
  (SELECT sr_customer_sk,
          sr_item_sk,
          sr_ticket_number
   FROM store_returns
   WHERE sr_returned_date_sk IN
       (SELECT d_date_sk
        FROM d2_filtered)),
     cs_filtered AS
  (SELECT cs_bill_customer_sk,
          cs_item_sk
   FROM catalog_sales
   WHERE cs_sold_date_sk IN
       (SELECT d_date_sk
        FROM d3_filtered)),
     intersected_keys AS
  (SELECT ss.ss_customer_sk,
          ss.ss_item_sk,
          ss.ss_ticket_number
   FROM ss_filtered ss
   WHERE EXISTS
       (SELECT 1
        FROM sr_filtered sr
        WHERE ss.ss_customer_sk = sr.sr_customer_sk
          AND ss.ss_item_sk = sr.sr_item_sk
          AND ss.ss_ticket_number = sr.sr_ticket_number)
     AND EXISTS
       (SELECT 1
        FROM cs_filtered cs
        WHERE ss.ss_customer_sk = cs.cs_bill_customer_sk
          AND ss.ss_item_sk = cs.cs_item_sk))
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
FROM intersected_keys k
JOIN store_sales ss ON k.ss_customer_sk = ss.ss_customer_sk
AND k.ss_item_sk = ss.ss_item_sk
AND k.ss_ticket_number = ss.ss_ticket_number
JOIN store_returns sr ON k.ss_customer_sk = sr.sr_customer_sk
AND k.ss_item_sk = sr.sr_item_sk
AND k.ss_ticket_number = sr.sr_ticket_number
JOIN catalog_sales cs ON k.ss_customer_sk = cs.cs_bill_customer_sk
AND k.ss_item_sk = cs.cs_item_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk;