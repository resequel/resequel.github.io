WITH sales_data AS
  (SELECT ss.ss_customer_sk,
          ss.ss_item_sk,
          ss.ss_sold_date_sk,
          ss.ss_quantity,
          ss.ss_store_sk,
          d1.d_date,
          ws.ws_sold_date_sk,
          ws.ws_warehouse_sk
   FROM store_sales ss
   JOIN date_dim d1 ON ss.ss_sold_date_sk = d1.d_date_sk
   JOIN item i ON ss.ss_item_sk = i.i_item_sk
   JOIN web_sales ws ON ss.ss_item_sk = ws.ws_item_sk
   AND ss.ss_customer_sk = ws.ws_bill_customer_sk
   WHERE d1.d_year = 2001
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
     AND ws.ws_wholesale_cost BETWEEN 80 AND 100)
SELECT cd.cd_gender,
       cd.cd_marital_status,
       cd.cd_education_status,
       hd.hd_vehicle_count,
       COUNT(*) AS cnt
FROM sales_data sd
JOIN date_dim d2 ON sd.ws_sold_date_sk = d2.d_date_sk
JOIN customer c ON sd.ss_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
JOIN inventory inv ON sd.ss_item_sk = inv.inv_item_sk
AND sd.ss_sold_date_sk = inv.inv_date_sk
AND sd.ws_warehouse_sk = inv.inv_warehouse_sk
JOIN store s ON sd.ss_store_sk = s.s_store_sk
JOIN warehouse w ON sd.ws_warehouse_sk = w.w_warehouse_sk
WHERE ca.ca_state IN ('IN',
                   'LA',
                   'NE',
                   'NM',
                   'OH')
  AND d2.d_date BETWEEN sd.d_date AND (sd.d_date + interval '30 day')
  AND inv.inv_quantity_on_hand >= sd.ss_quantity
  AND s.s_state = w.w_state
GROUP BY cd.cd_gender,
         cd.cd_marital_status,
         cd.cd_education_status,
         hd.hd_vehicle_count
ORDER BY cnt;