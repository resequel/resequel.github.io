WITH ss_sr_cs_joined AS
  (SELECT ss.ss_sold_date_sk,
          ss.ss_item_sk,
          ss.ss_net_profit,
          ss.ss_store_sk,
          sr.sr_returned_date_sk,
          sr.sr_net_loss,
          sr.sr_ticket_number,
          cs.cs_sold_date_sk AS cs_date_sk,
          cs.cs_net_profit,
          cs.cs_order_number
   FROM store_sales ss
   JOIN store_returns sr ON ss.ss_customer_sk = sr.sr_customer_sk
   AND ss.ss_item_sk = sr.sr_item_sk
   AND ss.ss_ticket_number = sr.sr_ticket_number
   JOIN catalog_sales cs ON sr.sr_customer_sk = cs.cs_bill_customer_sk
   AND sr.sr_item_sk = cs.cs_item_sk)
SELECT min(i.i_item_id),
       min(i.i_item_desc),
       min(s.s_store_id),
       min(s.s_store_name),
       min(j.ss_net_profit),
       min(j.sr_net_loss),
       min(j.cs_net_profit),
       min(j.ss_item_sk),
       min(j.sr_ticket_number),
       min(j.cs_order_number)
FROM ss_sr_cs_joined j
JOIN date_dim d1 ON j.ss_sold_date_sk = d1.d_date_sk
AND d1.d_moy = 6
AND d1.d_year = 2000
JOIN date_dim d2 ON j.sr_returned_date_sk = d2.d_date_sk
AND d2.d_year = 2000
AND d2.d_moy BETWEEN 6 AND 6 + 2
JOIN date_dim d3 ON j.cs_date_sk = d3.d_date_sk
AND d3.d_year = 2000
AND d3.d_moy BETWEEN 6 AND 6 + 2
JOIN item i ON j.ss_item_sk = i.i_item_sk
JOIN store s ON j.ss_store_sk = s.s_store_sk;