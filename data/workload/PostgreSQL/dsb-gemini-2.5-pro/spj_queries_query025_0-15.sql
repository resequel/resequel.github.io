
SELECT min(i_item_id),
       min(i_item_desc),
       min(s_store_id),
       min(s_store_name),
       min(ss_net_profit),
       min(sr_net_loss),
       min(cs_net_profit),
       min(ss_item_sk),
       min(sr_ticket_number),
       min(cs_order_number)
FROM
  (SELECT ss.*,
          i.i_item_id,
          i.i_item_desc,
          s.s_store_id,
          s.s_store_name
   FROM store_sales ss
   JOIN date_dim d1 ON d1.d_date_sk = ss.ss_sold_date_sk
   AND d1.d_moy = 6
   AND d1.d_year = 2000
   JOIN item i ON i.i_item_sk = ss.ss_item_sk
   JOIN store s ON s.s_store_sk = ss.ss_store_sk) ss_filtered
JOIN
  (SELECT sr.*
   FROM store_returns sr
   JOIN date_dim d2 ON d2.d_date_sk = sr.sr_returned_date_sk
   AND d2.d_year = 2000
   AND d2.d_moy BETWEEN 6 AND 6 + 2) sr_filtered ON ss_filtered.ss_customer_sk = sr_filtered.sr_customer_sk
AND ss_filtered.ss_item_sk = sr_filtered.sr_item_sk
AND ss_filtered.ss_ticket_number = sr_filtered.sr_ticket_number
JOIN
  (SELECT cs.*
   FROM catalog_sales cs
   JOIN date_dim d3 ON d3.d_date_sk = cs.cs_sold_date_sk
   AND d3.d_year = 2000
   AND d3.d_moy BETWEEN 6 AND 6 + 2) cs_filtered ON sr_filtered.sr_customer_sk = cs_filtered.cs_bill_customer_sk
AND sr_filtered.sr_item_sk = cs_filtered.cs_item_sk;