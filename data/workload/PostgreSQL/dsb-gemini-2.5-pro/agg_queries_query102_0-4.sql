WITH filtered_items AS
  (SELECT i_item_sk
   FROM item
   WHERE i_category IN ('Books',
                     'Home',
                     'Sports')
     AND i_manager_id IN (3,
                       15,
                       17,
                       26,
                       43,
                       44,
                       55,
                       70,
                       82,
                       95)),
     filtered_customers AS
  (SELECT c_customer_sk,
          c_current_cdemo_sk,
          c_current_hdemo_sk
   FROM customer
   JOIN customer_address ON c_current_addr_sk = ca_address_sk
   WHERE ca_state IN ('IN',
                   'LA',
                   'NE',
                   'NM',
                   'OH')),
     store_sales_filtered AS
  (SELECT ss.ss_item_sk,
          ss.ss_customer_sk,
          ss.ss_sold_date_sk,
          ss.ss_quantity,
          s.s_state,
          d.d_date,
          fc.c_current_cdemo_sk,
          fc.c_current_hdemo_sk
   FROM store_sales ss
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN store s ON ss.ss_store_sk = s.s_store_sk
   JOIN filtered_items fi ON ss.ss_item_sk = fi.i_item_sk
   JOIN filtered_customers fc ON ss.ss_customer_sk = fc.c_customer_sk
   WHERE d.d_year = 2001),
     web_sales_filtered AS
  (SELECT ws.ws_item_sk,
          ws.ws_bill_customer_sk,
          ws.ws_sold_date_sk,
          ws.ws_warehouse_sk,
          d.d_date
   FROM web_sales ws
   JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN filtered_items fi ON ws.ws_item_sk = fi.i_item_sk
   JOIN filtered_customers fc ON ws.ws_bill_customer_sk = fc.c_customer_sk
   WHERE ws.ws_wholesale_cost BETWEEN 80 AND 100)
SELECT cd.cd_gender,
       cd.cd_marital_status,
       cd.cd_education_status,
       hd.hd_vehicle_count,
       COUNT(*) AS cnt
FROM store_sales_filtered ssf
JOIN web_sales_filtered wsf ON ssf.ss_item_sk = wsf.ws_item_sk
AND ssf.ss_customer_sk = wsf.ws_bill_customer_sk
JOIN inventory inv ON ssf.ss_item_sk = inv.inv_item_sk
AND ssf.ss_sold_date_sk = inv.inv_date_sk
AND wsf.ws_warehouse_sk = inv.inv_warehouse_sk
JOIN warehouse w ON wsf.ws_warehouse_sk = w.w_warehouse_sk
JOIN customer_demographics cd ON ssf.c_current_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON ssf.c_current_hdemo_sk = hd.hd_demo_sk
WHERE wsf.d_date BETWEEN ssf.d_date AND (ssf.d_date + interval '30 day')
  AND inv.inv_quantity_on_hand >= ssf.ss_quantity
  AND ssf.s_state = w.w_state
GROUP BY cd.cd_gender,
         cd.cd_marital_status,
         cd.cd_education_status,
         hd.hd_vehicle_count
ORDER BY cnt;