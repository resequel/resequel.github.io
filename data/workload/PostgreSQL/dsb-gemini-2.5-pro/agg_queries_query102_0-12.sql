WITH filtered_customers AS
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
     filtered_items AS
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
     store_sales_base AS
  (SELECT ss.ss_item_sk,
          ss.ss_customer_sk,
          ss.ss_sold_date_sk,
          ss.ss_quantity,
          s.s_state,
          d.d_date
   FROM store_sales ss
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN store s ON ss.ss_store_sk = s.s_store_sk
   WHERE d.d_year = 2001),
     web_sales_base AS
  (SELECT ws.ws_item_sk,
          ws.ws_bill_customer_sk,
          ws.ws_sold_date_sk,
          ws.ws_warehouse_sk,
          d.d_date
   FROM web_sales ws
   JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
   WHERE ws.ws_wholesale_cost BETWEEN 80 AND 100)
SELECT cd.cd_gender,
       cd.cd_marital_status,
       cd.cd_education_status,
       hd.hd_vehicle_count,
       COUNT(*) AS cnt
FROM store_sales_base ssb
JOIN web_sales_base wsb ON ssb.ss_item_sk = wsb.ws_item_sk
AND ssb.ss_customer_sk = wsb.ws_bill_customer_sk
JOIN filtered_items fi ON ssb.ss_item_sk = fi.i_item_sk
JOIN filtered_customers fc ON ssb.ss_customer_sk = fc.c_customer_sk
JOIN inventory inv ON ssb.ss_item_sk = inv.inv_item_sk
AND ssb.ss_sold_date_sk = inv.inv_date_sk
AND wsb.ws_warehouse_sk = inv.inv_warehouse_sk
JOIN warehouse w ON wsb.ws_warehouse_sk = w.w_warehouse_sk
JOIN customer_demographics cd ON fc.c_current_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON fc.c_current_hdemo_sk = hd.hd_demo_sk
WHERE wsb.d_date BETWEEN ssb.d_date AND (ssb.d_date + interval '30 day')
  AND inv.inv_quantity_on_hand >= ssb.ss_quantity
  AND ssb.s_state = w.w_state
GROUP BY cd.cd_gender,
         cd.cd_marital_status,
         cd.cd_education_status,
         hd.hd_vehicle_count
ORDER BY cnt;