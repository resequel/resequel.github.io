WITH customer_filtered AS
  (SELECT c.c_customer_sk,
          cd.cd_gender,
          cd.cd_marital_status,
          cd.cd_education_status,
          hd.hd_vehicle_count
   FROM customer c
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   AND ca.ca_state IN ('IN',
                   'LA',
                   'NE',
                   'NM',
                   'OH')
   JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
   JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk),
     store_sales_filtered AS
  (SELECT ss.ss_item_sk,
          ss.ss_customer_sk,
          d1.d_date
   FROM store_sales ss
   JOIN date_dim d1 ON ss.ss_sold_date_sk = d1.d_date_sk
   AND d1.d_year = 2001
   JOIN item i ON ss.ss_item_sk = i.i_item_sk
   AND i.i_category IN ('Books',
                     'Home',
                     'Sports')
   AND i.i_manager_id IN (3,
                       15,
                       17,
                       26,
                       43,
                       44,
                       55,
                       70,
                       82,
                       95)
   JOIN inventory inv ON ss.ss_item_sk = inv.inv_item_sk
   AND ss.ss_sold_date_sk = inv.inv_date_sk
   AND inv.inv_quantity_on_hand >= ss.ss_quantity),
     web_sales_filtered AS
  (SELECT ws.ws_item_sk,
          ws.ws_bill_customer_sk,
          d2.d_date,
          w.w_state
   FROM web_sales ws
   JOIN date_dim d2 ON ws.ws_sold_date_sk = d2.d_date_sk
   JOIN warehouse w ON ws.ws_warehouse_sk = w.w_warehouse_sk
   WHERE ws.ws_wholesale_cost BETWEEN 80 AND 100)
SELECT cf.cd_gender,
       cf.cd_marital_status,
       cf.cd_education_status,
       cf.hd_vehicle_count,
       count(*) AS cnt
FROM store_sales_filtered ssf
JOIN web_sales_filtered wsf ON ssf.ss_item_sk = wsf.ws_item_sk
AND ssf.ss_customer_sk = wsf.ws_bill_customer_sk
JOIN customer_filtered cf ON ssf.ss_customer_sk = cf.c_customer_sk
JOIN store s ON s.s_state = wsf.w_state
WHERE wsf.d_date BETWEEN ssf.d_date AND (ssf.d_date + interval '30 day')
GROUP BY cf.cd_gender,
         cf.cd_marital_status,
         cf.cd_education_status,
         cf.hd_vehicle_count
ORDER BY cnt;